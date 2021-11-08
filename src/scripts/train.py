import sys, os, inspect
from os.path import join
import argparse
import time
import torch
import numpy as np
import random
import matplotlib.pyplot as plt
SCRIPT_FOLDER = os.path.realpath(os.path.abspath(
    os.path.split(inspect.getfile(inspect.currentframe()))[0]))
PROJECT_FOLDER = join(SCRIPT_FOLDER, os.pardir)
sys.path.insert(0, PROJECT_FOLDER)
from src.models.rnn import RNNModel
from src.models.convergence import ConvergenceCriterion, ConvergenceCriteria
from src.models.myUtils import prepare_tensors_sgd, input_to_indexs,  init_seed, prepare_sequences



def one_hot_encode(sequence, dict_size, seq_len, batch_size):
    # Creating a multi-dimensional array of zeros with the desired output shape
    features = np.zeros((batch_size, seq_len, dict_size), dtype=np.float32)

    # Replacing the 0 at the relevant character index with a 1 to represent that character
    for i in range(batch_size):
        for u in range(seq_len):
            features[i, u, sequence[i][u]] = 1
    return features


def log_cuda_usage(fh):

    fh.write("Using cuda: ")
    fh.write(torch.cuda.get_device_name(0))
    fh.write('\nMemory Usage:\n')
    fh.write('Allocated: %f GB\n'%round(torch.cuda.memory_allocated(0)/1024**3,1))
    fh.write('Cached:   %f GB\n'%round(torch.cuda.memory_cached(0)/1024**3,1))

if __name__ == "__main__":


    parser = argparse.ArgumentParser()
    parser.add_argument("--seed",  type=int, help="Seed for training neural network.")
    parser.add_argument("--language",  type=str, help="Language to train on.")
    parser.add_argument("--delay",  type=int, help="If smaller than 1, then normal RNN. Otherwise, delayed-RNN.")
    parser.add_argument("--direction",  type=str, help="Options: forward, backward or bidirectional.")
    parser.add_argument("--hidden_dim",  type=int, help="Size of hidden layer.")
    parser.add_argument("--embedding_dim", type=int, help="Size of word embeddings.")
    parser.add_argument("--lr",  type=float, help="Learning rate for training neural network.")
    parser.add_argument("--input_data", type=str, help="File with sentences to train on.")
    #ToDo comment this line for safer mode (it's just useful for debugging purposes)
    #parser.set_defaults(seed=8, language="eng", delay=0, direction="bidirectional", hidden_dim=250, embedding_dim=100, lr=0.01, input_data="../data/eng_0_60_cds_utterances_cleaned_first_10.txt")
    args = parser.parse_args()

    #Check parameters
    assert(args.language in args.input_data)
    directions=["forward", "backward", "bidirectional"]
    assert(args.direction in directions)


    #Initialize the seed
    init_seed(args.seed)

    #Set gpu if available
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')


    # Load data
    with open(args.input_data) as f:
        sentences = f.read().splitlines()  # read raw lines into an array
    # Reverse sentences if training backwards
    if args.direction == "backward":
        sentences=[" ".join(s.split()[::-1]) for s in sentences]


    #Prepare folder to save trained models
    path_to_saved_models=join(PROJECT_FOLDER, "saved_models")
    #Set logging file
    flog="training_log_%s_%s_%idelay_seed_%i"%(args.language, args.direction, args.delay, args.seed)
    with open(flog,"w") as fh:
        fh.write("Training on file {}\n".format(args.input_data))
        if device.type == 'cuda':
            log_cuda_usage(fh)


    #Prepare input data (mappings and lists of indices)
    word_mappings, all_sentences_indexed = input_to_indexs(sentences, args.delay)
    dict_size = len(word_mappings.s2i)

    #We update after every sentence
    batch_size = 1

    # Instantiate the model
    hyperparams = {"hidden_dim": args.hidden_dim,
                   "embedding_dim": args.embedding_dim,
                   "n_rnn_layers": 1,
                   "output_size": dict_size,
                   "direction": args.direction}
    rnn = RNNModel(hyperparams, device)
    rnn.to(device)

    #Instantiate an optimizer
    optimizer = torch.optim.SGD(rnn.parameters(), lr=args.lr)

    #Create a loss function
    loss_function = torch.nn.NLLLoss()

    #Initialize other vars
    options = {}
    options["max_epochs_stagnated"] = 10
    min_change = options["min_change"] = 0.0025
    criteria = [ConvergenceCriterion("loss", options)]
    convergence_criteria = ConvergenceCriteria(criteria, "or")
    loss_all_epochs = []
    converged=False
    epoch=0

    #Start training
    while not converged:
        epoch+=1
        be=time.perf_counter()
        
        running_loss = 0.0
        loss_values = []

        #Shuffle the sentences
        random.shuffle(all_sentences_indexed)

        # Get sequences of inputs and targets
        inputs, targets = prepare_sequences(all_sentences_indexed)

        # Get tensors of inputs and targets, and add delay if required
        inputs_t, targets_t = prepare_tensors_sgd(inputs, targets, args.delay, device)
        
        losses_sentences = []

        #We present each sentence separately
        for i, input in enumerate(inputs_t):
            target = targets_t[i]

            # Clean the gradient data so that it doesn't accumulate (SGD)
            optimizer.zero_grad()

            #Run forward pass for this sentence
            #output shape: sentence_length*vocabulary_size
            output, hidden = rnn.forward(input.unsqueeze(0)) #we add the batch dimension (which is always 1)

            #Compute the loss
            #the loss function expects dimensions n_inputs * output_size
            output=output.squeeze(0) #we remove the batch dimension
            if args.delay > 0:
                output = output[args.delay:, :] #shift: we ignore the first outputs (delay)

            loss = loss_function(output, target)

            # Backprop (compute the gradient)
            loss.backward()

            # Update the weights of the neural network
            optimizer.step()
            
            # keep track of loss values to plot them
            # running_loss += loss.item() * target.size(0) #target?output? #RGA it's the same

            losses_sentences.append(loss.item())

        # losses_sentences=train_step_sgd(rnn, optimizer, loss_function, inputs_t, targets_t)

        loss_epoch = np.mean(losses_sentences)
        loss_all_epochs.append(loss_epoch)

        #Check whether it's time to stop training
        convergence_criteria.update_state(epoch, loss_all_epochs, None, None, None)
        converged=convergence_criteria.converged()

        time_epoch=time.perf_counter()-be

        #Report
        line="Epoch: {}   Loss: {:.4f} Time: {:.3f}\n".format(epoch, loss_epoch, time_epoch)
        with open(flog, "a") as fh:
            fh.write(line)
#            if device.type == 'cuda':
#                log_cuda_usage(fh)

        if epoch%10 == 0:
            print(line)


        if epoch%5 == 0:
            print("Saving intermediate model at epoch %i..."%epoch)
            model_folder = rnn.save_model(path_to_saved_models, word_mappings, epoch, args)


    #Save the final model
    model_folder = rnn.save_model(path_to_saved_models, word_mappings, epoch, args)
    print("Model saved at %s"%model_folder)

    #Plot the losses
    plt.plot(loss_all_epochs)
    plt.ylabel("Loss")
    plt.xlabel("Epoch")
    plt.title("Train losses {}".format(args.language))
    plt.savefig(join(model_folder, "loss.{}.png".format(args.language)))
