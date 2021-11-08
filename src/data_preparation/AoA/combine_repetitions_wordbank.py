import sys
import pandas as pd


def main(fname):
    print("Computing means of file %s"%fname)
    df=pd.read_csv(fname, sep=";")
    col = "uni_lemma" if "eng" in fname else "definition"
    sdf=df[[col, "lexical_class", "aoa",]]
    gsdf=sdf.groupby([col,"lexical_class"]).mean()
    newfname=fname.replace(".csv","_means.csv")
    print("Saving them in file %s"%newfname)
    gsdf.to_csv(newfname, sep=";")

if __name__=="__main__":

    args=sys.argv[1:]
    if len(args) != 1:
        print("Usage: combine_repetitions_wordbank.py <file>")
        exit(-1)
    main(*args)
