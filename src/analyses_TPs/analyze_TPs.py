import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

#color-blind safe palette: https://personal.sron.nl/~pault/#sec:qualitative
palette={"ita":"#4477AA", "eng":"#CCBB44"}

def tps_violin_per_lang(itaAN, itaNA, engAN, itaAll, engAll):
    all=pd.concat([itaAll, engAll], ignore_index = True)
    ax=sns.violinplot(data=all, x="direction", y="prob", hue="lang", palette=palette, bw=.15, cut=0)
    sns.despine(left=True)
    ax.set_ylim([-0.1, 1.15])
    plt.savefig("all.png")
    plt.clf()
    return

def tps_violinplots(itaAN, itaNA, engAN, itaAll, engAll):
    sns.set_theme(style="whitegrid")

    all=pd.concat([itaAll, engAll], ignore_index = True)


    #FW/BW (all pairs together)
    ax=sns.violinplot(data=all, x="direction", y="prob", hue="lang", palette=palette, bw=.15, cut=0)
    sns.despine(left=True)
    ax.set_ylim([-0.1, 1.15])
    plt.savefig("all.png")
    plt.clf()

    #With direction

    #Adj-N
    adjn = pd.concat([itaAN, engAN], ignore_index=True)
    sns.violinplot(data=adjn, x="direction", y="prob", hue="lang", palette=palette, bw=.25, cut=0)
    sns.despine(left=True)
    ax.set_ylim([-0.1, 1.15])
    plt.title("Adj-N")
    plt.savefig("adj_n.png")
    plt.clf()
    #fwengMean=engAN[engAN.direction=="fw"].prob.mean()
    #bwengMean=engAN[engAN.direction=="bw"].prob.mean()
    #fwitaMean=itaAN[itaAN.direction=="fw"].prob.mean()
    #print("English FW mean", fwengMean)
    #print("English BW mean", bwengMean)

    #N-Adj
    sns.violinplot(data=itaNA, x="direction", y="prob", palette={"fw": palette["ita"], "bw": palette["ita"]}, \
                   bw=.25, cut=0)
    sns.despine(left=True)
    ax.set_ylim([-0.1, 1.15])
    plt.title("N-Adj")
    plt.savefig("n_adj.png")
