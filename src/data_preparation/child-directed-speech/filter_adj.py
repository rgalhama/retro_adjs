import sys, os, inspect
from os.path import join
from src.tagger import Tagger

SCRIPT_FOLDER = os.path.realpath(os.path.abspath(
    os.path.split(inspect.getfile(inspect.currentframe()))[0]))
sys.path.insert(0, join(SCRIPT_FOLDER, os.pardir))

def partial_output(selected, nmbr):
    with open(join(SCRIPT_FOLDER, "../../data/tmp/{}_AN_NA_{}.txt".format(lang,nmbr)), "w") as fh:
        fh.write("\n".join(selected))
        fh.write("\n")


def main( dataf, tagger, negf=None):

    selected=[]
    j=0

    with open(dataf, "r") as fh:
        for line in fh:
            j+=1
            if j%1000 == 0:
                print("%i sentences parsed"%j)
                partial_output(selected, j)
                selected=[]
            sentence=line.strip()
            parsed = tagger.parseSentence(sentence)
            for i, word in enumerate(parsed):
                nextword=""
                if (i+1) < len(parsed):
                    nextword=parsed[i+1]
                else:
                    break
                if (tagger.isNoun(word) and tagger.isAdj(nextword)) or (tagger.isAdj(word) and tagger.isNoun((nextword))):
                    selected.append(sentence)
                    break

    if selected:
        print("%i sentences parsed" % j)
        partial_output(selected, j)


if __name__ == "__main__":

    lang="ita"
    if len(sys.argv) > 1:
        lang = sys.argv[1]

    #Data
    dataf="../../data/child-directed-speech/ita_0_60_cds_utterances_cleaned.txt"

    #Tagger
    tagger=Tagger(lang)

    main(dataf, tagger )
