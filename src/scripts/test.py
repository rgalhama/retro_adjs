import os, sys, inspect, argparse
from os.path import join, isfile
from os import remove
import json
import torch
import pandas as pd

# Add src folder to path
SCRIPT_FOLDER = os.path.realpath(os.path.abspath(
    os.path.split(inspect.getfile(inspect.currentframe()))[0]))
sys.path.insert(0, join(SCRIPT_FOLDER, os.pardir))
from src.models.rnn import RNNModel
from src.models.s2i import String2IntegerMapper
from src.tagger import Tagger
from src.metrics.metrics import get_perword_metrics_sentence
from src.models.myUtils import prepare_tensors_sgd, prepare_sequences, sentences2indexs, init_seed


def load_saved_model(path, device):
    # Load hyperparameters
    hyperparams = json.load(open(join(path, "hyperparams.json")))

    # Create base model
    rnn = RNNModel(hyperparams, device)
    rnn.to(device)

    # Load saved parameters (weights)
    params_state_dict = torch.load(join(path, "model"), map_location=device)
    missing_keys = rnn.load_state_dict(params_state_dict)

    return rnn

def forward_test(lang):
    header = "lang;actual_word;actual_tag;next_word;next_tag;correct;entropy;entropytop10;surprisal;target_in_top10"
    for i, input in enumerate(inputs_t):
        target_words = targets_t[i]
        # print("Testing sentence %i: %s" % (i, sentences[i]))

        # output size: n_words_sentence x n_words_vocabulary
        output, hidden = model.forward(input.unsqueeze(0))
        output = output.squeeze(0)  # we remove the batch dimension

        if args.delay > 0:
            output = output[args.delay:, :]  # shift: we ignore the first outputs (delay)

        sentence = (beginning + " " + sentences[i] + " " + ending).split(" ")

        # Get array of pos tags
        posTags = [word.pos_ + " " + word.tag_ for word in parsed_sentences[i]]
        posTags.insert(0, beginning)
        posTags.append(ending)
        # Correction for words that have more than one tag
        # This happens for apostrophes, and for contractions like "gonna"
        while len(posTags) > len(sentence):
            for j, pw in enumerate(sentence):
                w = str(pw)
                if "\'" in w or w == "gonna" or w == "gotta":  # or ("PART" in posTags[j]):
                    del posTags[j]
                    break

        # Get proportion of correct word predictions (argmax) in a sentence, and other metrics
        sentence_metrics = get_perword_metrics_sentence(output, target_words, sentence, posTags)

        # Save results
        lens = [len(x) for x in sentence_metrics.values()]
        if (len(set(lens)) != 1):
            print("Problem with sentence ", sentence, posTags, lens)
        sentence_metrics["lang"]=lang
        partialdf = pd.DataFrame.from_dict(sentence_metrics)
        partialdf.to_csv(outputf, mode='a', header=header, index=False)
        header = False

        # Show mean accuracy of sentence
        #print("Mean accuracy:: ", partialdf["correct"].mean())

    print("Results saved in %s"%outputf)

if __name__ == "__main__":

    # print(os.getcwd())

    parser = argparse.ArgumentParser()
    parser.add_argument("--seed", type=int, help="Seed for training neural network.")
    parser.add_argument("--language", type=str, help="Language to train on.")
    parser.add_argument("--direction", type=str, help="Options: forward, backward or bidirectional.")
    parser.add_argument("--delay", type=int, help="If smaller than 1, then normal RNN. Otherwise, delayed-RNN.")
    parser.add_argument("--path_to_model", type=str, help="Saved model.")
    parser.add_argument("--input_data", type=str, help="File with sentences to test on.")

    # comment this line (this is just for debugging)
    # parser.set_defaults(seed=84, language="eng", delay=2, direction="forward", input_data="../data/eng_0_60_cds_utterances_cleaned_first_2.txt", path_to_model="../saved_models/model_eng_forward_2delay_seed_84_epoch_480")

    args = parser.parse_args()

    # Check command line options
    assert (args.language in args.input_data)
    directions = ["forward", "backward", "bidirectional"]
    assert (args.direction in directions)

    # Set output file and remove if already exists
    outputf = join(args.path_to_model, 'accuracies_test.csv')
    if isfile(outputf):
        remove(outputf)

    # Initialize the seed
    init_seed(args.seed)

    # Set gpu if available
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

    # Load data to test (for now let's just take any of the small files we have)
    with open(args.input_data, encoding="utf-8") as f:
        sentences = f.read().splitlines()  # read raw lines into an array

    # Reverse sentences if training backwards
    if args.direction == "backward":
        sentences = [" ".join(s.split()[::-1]) for s in sentences]

    # Load saved model
    model = load_saved_model(args.path_to_model, device)
    # Load string to int mappers
    mappings = String2IntegerMapper.load(join(args.path_to_model, "w2i"))

    # Instantiate a tagger
    tgr = Tagger(args.language)
    parsed_sentences = [tgr.parseSentence(s) for s in sentences]

    # Convert sentences to indexs
    beginning = "<s>"
    ending = "</s>"
    all_sentences_indexed = sentences2indexs(sentences, beginning, ending, mappings)
    inputs, targets = prepare_sequences(all_sentences_indexed)
    # Put them as tensors
    inputs_t, targets_t = prepare_tensors_sgd(inputs, targets, args.delay, device)

    # Run one forward pass of the model with the data, and collect the output
    forward_test(args.language)