# bar plot of amount of Italian adj-noun and noun-adj pairs
"""
Created on Tue Jun 23 13:49:31 2020

@author: fzermiani
"""
import pandas as pd
import matplotlib.pyplot as plt

def plot_ita_AN_NA_counts(amount_AN, amount_NA):

    #Graph
    width = 0.7
    plt.bar(["AN", "NA"], [amount_AN, amount_NA], width=width)
    #plt.bar(amount_NA, width)
    plt.xlabel("Sentences with Adj-Noun and Noun-Adj.")
    plt.ylabel("amount")
    #plt.show()
    plt.ylim(0,100)
    plt.savefig("ita_AN_vs_NA.png")

    return amount_AN, amount_NA


def plot_types_adjs(amount_adjtypes_AN, amount_adjtypes_NA):

    plt.clf()
    width = 0.7
    plt.bar(["AN", "NA"], [amount_adjtypes_AN, amount_adjtypes_NA], width=width)
    #plt.bar(amount_NA, width)
    plt.xlabel("Number of different adjectives in Adj-Noun and Noun-Adj.")
    plt.ylabel("Amount")
    plt.ylim(0,100)
    #plt.show()
    plt.savefig("ita_AN_vs_NA_types.png")
    #The bar for AN seems to have reduced more, but there are still more!

def typetokenratio(amount_adjtypes_AN, amount_adjtypes_NA, amount_AN, amount_NA):

    type_token_ratioAN=amount_adjtypes_AN/amount_AN
    type_token_ratioNA=amount_adjtypes_NA/amount_NA
    plt.clf()
    width = -1.7
    plt.bar(["AN", "NA"], [type_token_ratioAN, type_token_ratioNA], width=width)
    #plt.bar(amount_NA, width)
    plt.xlabel("Type-token ratio in Adj-Noun and Noun-Adj.")
    plt.ylabel("Amount")
    #plt.show()
    plt.savefig("ita_AN_vs_NA_typetokenratio.png")



def report(ntype_adjsAN, ntype_adjsNA, ntype_adjsENG, ntokens_adjsAN, ntokens_adjsNA, ntokens_adjsENG):

    print("Italian")
    print("Number of adjective types in AN constructions: %i"%ntype_adjsAN)
    print("Number of adjective types in NA constructions: %i"%ntype_adjsNA)
    print("English")
    print("Number of adjective types in AN constructions: %i"%ntype_adjsENG)

    print("Italian")
    print("Number of adjective tokens in AN constructions: %i"%ntokens_adjsAN)
    print("Number of adjective tokens in NA constructions: %i"%ntokens_adjsNA)
    print("English")
    print("Number of adjective tokens in AN constructions: %i"%ntokens_adjsENG)


    print("\n\n")
    print("Type/token ratio based on adjectives")
    print("Italian")
    print("Type/Token ratio in AN constructions: %.2f"%(ntype_adjsAN/ntokens_adjsAN))
    print("Type/Token ratio in NA constructions: %.2f"%(ntype_adjsNA/ntokens_adjsNA))
    print("Type/Token ratio both constructions: %.2f"%((ntype_adjsNA+ntype_adjsNA)/(ntokens_adjsNA+ntokens_adjsAN)))

    print("English")
    print("Type/token ratio in AN constructions: %.2f"%(ntype_adjsENG/ntokens_adjsENG))
    #print("The type/token ratio is much smaller for English! This is because there are many more adjectives in English \
    #      than in Italian (i.e. for n sentences in each language, English sentences will have many more Adjectives)")

def main(itaAN, itaNA, engAN):


    #Get adjective column (::2 because it is repeated for fw and bw)
    ita_AN_adjs = itaAN[['word']].iloc[::2]
    ita_NA_adjs = itaNA[['nextword']].iloc[::2]
    eng_adjs = engAN[['word']].iloc[::2]

    #Tokens
    ntokens_adjsAN=len(ita_AN_adjs)
    ntokens_adjsNA=len(ita_NA_adjs)
    ntokens_adjsENG=len(eng_adjs)

    #Types
    ntype_adjsAN=len(pd.unique(ita_AN_adjs.word))
    ntype_adjsNA=len(pd.unique(ita_NA_adjs.nextword))
    ntype_adjsENG=len(pd.unique(eng_adjs.word))

    # Report
    report(ntype_adjsAN, ntype_adjsNA, ntype_adjsENG, ntokens_adjsAN, ntokens_adjsNA, ntokens_adjsENG)


    # GRAPHS (ToDo: add English)

    # Plot nmbr AN vs NA in Italian
    #plot_ita_AN_NA_counts(ntokens_adjsAN, ntokens_adjsNA)

    #Plot adj types in Italian
    #plot_types_adjs(ntype_adjsAN, ntype_adjsNA)

    # Now let's look at the type-token ratio
    #typetokenratio(ntype_adjsAN, ntype_adjsNA, ntokens_adjsAN, ntokens_adjsNA)
