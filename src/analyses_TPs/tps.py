from collections import Counter
import pandas as pd
import nltk
from src.tagger import Tagger


def get_counts(dataf):
    with open(dataf, "r") as fh:
        # Get counts
        raw = fh.read()
        # tokens = nltk.word_tokenize(raw)
        tokens = raw.split()
        unigrm = Counter(tokens)
        bigrm = nltk.bigrams(tokens)
        bigrm_fdist = nltk.FreqDist(bigrm)
    return unigrm, bigrm_fdist


def get_tps(word, nextword, unigrm, bigrm):
    counts_word = unigrm[str(word)]
    counts_next = unigrm[str(nextword)]
    counts_bigram = bigrm[(str(word), str(nextword))]
    # There can be a count of 0 in rare cases when spacy removes apostrophes (e.g. c')
    fwtp = 0 if counts_word == 0 else (counts_bigram / counts_word)
    bwtp = 0 if counts_next == 0 else (counts_bigram / counts_next)
    return fwtp, bwtp


def main(lang, dataf, prefix=""):
    # Find N-Adj, Adj-N pairs and get their FW-TP and BW-TP
    adjnoun = []
    nounadj = []
    alls = []
    j = 0

    # Tagger
    tagger = Tagger(lang)

    # Get unigrams and bigrams
    print("Getting counts...")
    unigrm, bigrm = get_counts(dataf)
    print("Counts done.")

    with open(dataf, "r") as fh:
        for line in fh:
            j += 1
            if j % 1000 == 0:
                print("%i sentences parsed" % j)
            sentence = line.strip()
            parsed = tagger.parseSentence(sentence)
            for i, word in enumerate(parsed):
                nextword = ""
                if (i + 1) < len(parsed):
                    nextword = parsed[i + 1]

                # There can be a count of 0 in rare cases when spacy removes apostrophes (e.g. c')
                if unigrm[str(word)] == 0 or unigrm[str(nextword)] == 0:
                    pass
                else:
                    # Adj-Noun
                    if tagger.isAdj(word) and tagger.isNoun(nextword):
                        # print("Adj-N", word, nextword)
                        fw, bw = get_tps(word, nextword, unigrm, bigrm)
                        adjnoun.append([lang, word, nextword, "fw", fw])
                        adjnoun.append([lang, word, nextword, "bw", bw])
                        alls.append([lang, "fw", fw])
                        alls.append([lang, "bw", bw])

                    # Noun-Adj
                    if tagger.isNoun(word) and tagger.isAdj(nextword):
                        # print("N-adj", word, nextword)
                        fw, bw = get_tps(word, nextword, unigrm, bigrm)
                        nounadj.append([lang, word, nextword, "fw", fw])
                        nounadj.append([lang, word, nextword, "bw", bw])
                        alls.append([lang, "fw", fw])
                        alls.append([lang, "bw", bw])

    # Create dataframes
    ANdf = pd.DataFrame(adjnoun, columns=["lang", "word", "nextword", "direction", "prob"])
    NAdf = pd.DataFrame(nounadj, columns=["lang", "word", "nextword", "direction", "prob"])
    alldf = pd.DataFrame(alls, columns=["lang", "direction", "prob"])

    # Save them to file
    ANdf.to_csv("{}_{}_AdjNoun_tps.csv".format(prefix, lang), sep=";")
    NAdf.to_csv("{}_{}_NounAdj_tps.csv".format(prefix, lang), sep=";")
    alldf.to_csv("{}_{}_tps.csv".format(prefix, lang), sep=";")



