import pandas as pd
import tps, analyze_TPs, counts

if __name__ == "__main__":

    langs=["eng", "ita"]
    adjs_datafile="../data/adjective_sentences_cds/%s_AN_NA.txt"

    # 1. Compute TPs
#    for lang in langs:
#        tps.main(lang, adjs_datafile % lang)
    # 1.1. Compute TPs also of English with a sample size matched to Italian (i.e. matched by number of adjectives,\
    # instead of matched by number of sentences)
    tps.main("eng", "../data/adjective_sentences_cds/eng_AN_NA_300.txt", prefix="eng300")

    # 2. Load data
    itaAN = pd.read_csv("{}_AdjNoun_tps.csv".format("ita"), sep=";")
    itaNA = pd.read_csv("{}_NounAdj_tps.csv".format("ita"), sep=";")
    itaAll = pd.read_csv("{}_tps.csv".format("ita"), sep=";")
    engAN = pd.read_csv("{}_AdjNoun_tps.csv".format("eng"), sep=";")
    engNA = pd.read_csv("{}_NounAdj_tps.csv".format("eng"), sep=";")
    engAll = pd.read_csv("{}_tps.csv".format("eng"), sep=";")
    engAN300 = pd.read_csv("eng300_{}_AdjNoun_tps.csv".format("eng"), sep=";")
    engAll300 = pd.read_csv("eng300_{}_tps.csv".format("eng"), sep=";")

    # 2. Type and token counts
    #counts.main(itaAN, itaNA, engAN)

    # 3. Analyze
    #analyze_TPs.tps_violinplots(itaAN, itaNA, engAN, itaAll, engAll)
    #analyze_TPs.tps_violin_per_lang(itaAN, itaNA, engAN, itaAll, engAll)
    analyze_TPs.tps_violin_per_lang(itaAN, itaNA, engAN300, itaAll, engAll300)

    # 4. plot_TPs.R