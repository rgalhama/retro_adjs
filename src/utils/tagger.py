import os, sys, inspect
from os.path import join
import spacy

# print(spacy.__version__)
nlp = spacy.load("en_core_web_sm")
nlp = spacy.load("it_core_news_sm")

SCRIPT_FOLDER = os.path.realpath(os.path.abspath(
    os.path.split(inspect.getfile(inspect.currentframe()))[0]))

NEG_ADJS_ITALIAN_FILE = join(SCRIPT_FOLDER, "../../data/negative_lists/negative_list_adjs_italian.txt")
NEG_NOUNS_ITALIAN_FILE = join(SCRIPT_FOLDER, "../../data/negative_lists/negative_list_nouns_italian.txt")
NEG_ADJS_ENGLISH_FILE = join(SCRIPT_FOLDER, "../../data/negative_lists/negative_list_adjs_english.txt")


class Tagger():
    # See list of tags https://spacy.io/api/annotation
    def __init__(self, lang):
        self.lang = lang
        if lang == "ita":
            nlp = spacy.load("it_core_news_sm", disable=["tokenizer", "parser"])
            self.negative_list_adjs = self.load_negative(NEG_ADJS_ITALIAN_FILE)
            self.negative_list_nouns = self.load_negative(NEG_NOUNS_ITALIAN_FILE)
        elif lang == "eng":
            nlp = spacy.load("en_core_web_sm", disable=["tokenizer", "parser"])
            self.negative_list_adjs = self.load_negative(NEG_ADJS_ENGLISH_FILE)
        else:
            raise Exception("Unknown language %s" % lang)

    def load_negative(self, negf):
        negadjs = []
        with open(negf, "r") as fh:
            for line in fh:
                negadjs.append(line.strip())
        return negadjs

    def isAdj(self, word):
        if type(word) == str:
            if word == "" or word == "\'":
                return False
            word = nlp(word)[0]
        if str(word) in self.negative_list_adjs:
            return False
        else:
            return word.pos_ == "ADJ" and word.tag_ == "JJ"

    def isNoun(self, word):
        if type(word) == str:
            if word == "" or word == "\'":
                return False
            word = nlp(word)[0]
        if (self.lang == "ita") and (str(word) in self.negative_list_nouns):
            return False
        else:
            return word.pos_ == "NOUN"

    def parseSentence(self, sentence):
        with nlp.disable_pipes("ner", "parser"):
            doc = nlp(sentence)
        return doc


# Example use
if __name__ == "__main__":
    enTagger = Tagger("ita")
    print(enTagger.isAdj("ma cosa succede"))

##Example
# sentence = nlp("La bianca casa")
# for token in sentence:
#     print(token.text, token.lemma_, token.pos_, token.tag_, token.dep_,
#           token.shape_, token.is_alpha, token.is_stop)
