import os, sys
from string import Template
from analyses_predictions_nn import *

path_to_data="../../saved_models/"
model_fname_template = Template("model_${lang}_${direction}_${delay}delay_seed_${seed}_epoch_${epoch}/accuracies_test.csv")

def get_path_to_data(lang, direction, delay, seed, epoch):
    fname = model_fname_template.substitute(lang=lang, direction=direction, delay=delay, seed=seed, epoch=epoch)
    return os.path.join(path_to_data, fname)

def get_df_construction(df, direction):
    """
        Given a dataframe containing the evaluation metrics for all words in sentences,
        retrieve only those rows corresponding to Adj-Noun or Noun-Adj.
    """

    if direction == "forward":
        an_df = df[df.actual_pos.str.startswith("ADJ")][df.next_tag.str.startswith("NOUN")]
        an_df["construction"]="AdjNoun"
        na_df = df[df.actual_pos.str.startswith("NOUN")][df.next_tag.str.startswith("ADJ")]
        na_df["construction"]="NounAdj"
    else:
        raise NotImplementedError

    return an_df, na_df

def add_langconstr(df):
    df["langconstr"] = df["lang"] + "_" + df["construction"]
    return df

def prepare_data(engdf, itadf):

    #Separate data into syntactic patterns
    engAN, _= get_df_construction(engdf, "forward")
    itaAN, itaNA = get_df_construction(itadf, "forward")
    #Add column with lang_constr (e.g. eng_AdjNoun
    engAN = add_langconstr(engAN)
    itaAN = add_langconstr(itaAN)
    itaNA = add_langconstr(itaNA)
    #Put data together
    df=pd.concat([engAN, itaAN, itaNA])

    return df

def main(eng_rnn_path, ita_rnn_path, eng_delay1_path, ita_delay1_path, direction):

    # Read data
    eng_rnn = pd.read_csv(eng_rnn_path)
    ita_rnn = pd.read_csv(ita_rnn_path)
    eng_delay1 = pd.read_csv(eng_delay1_path)
    ita_delay1 = pd.read_csv(ita_delay1_path)

    # Prepare dataframes
    rnndf = prepare_data(eng_rnn, ita_rnn)
    delay1df = prepare_data(eng_delay1, ita_delay1)

    ## GRAPHS ##

    #Graphs with surprisal on next word prediction
    violin_surprisal(rnndf, "surprisal_rnn_%s.png"%direction)
    violin_surprisal(delay1df, "surprisal_drnn1.png"%direction)

    #Graphs of correct predictions (0/1)
    violin_correct(rnndf, "correct_predictions_rnn_%s.png"%direction)
    violin_correct(delay1df, "correct_predictions_drnn1_%s.png"%direction)

    #Graphs showing whether word is in top 10
    plot_correcttop10(rnndf, "correct_top10_rnn_%s.png"%direction)
    plot_correcttop10(delay1df, "correct_top10_drnn1_%s.png"%direction)

    return

if __name__ == "__main__":

    ## Get paths to data with computed metrics ##

    if len(sys.argv) == 1:
        #Run with hardcoded paths
        #RNN (forward)
        eng_rnn_path = get_path_to_data("eng", "forward", "0", "2342", "62")
        ita_rnn_path = get_path_to_data("ita", "forward", "0", "2342", "59")

        #RNN (delay)
        eng_delay1_path = get_path_to_data("eng", "forward", "1", "745", "60")
        ita_delay1_path = get_path_to_data("ita", "forward", "1", "744", "60")

        direction = "forward"

        ## Run the whole analyses (prepare data, produce graphs) ##
        main(eng_rnn_path, ita_rnn_path, eng_delay1_path, ita_delay1_path, direction)

    elif len(sys.argv) == 6:
        main(*sys.argv[1:])
    else:
        print("I don't understand the provided arguments.")
        print("Usage: path_to_rnn_eng path_to_rnn_ita path_to_delay1_eng path_to_delay1_ita direction")
        exit(-1)

