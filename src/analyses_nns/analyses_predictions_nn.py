import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from plotnine import *

# color-blind safe palette: https://personal.sron.nl/~pault/#sec:qualitative
palette = {"ita": "#4477AA", "eng": "#CCBB44"}


def violin_surprisal(df, fname):
    vplot = ggplot(df, aes(x="langconstr", y="surprisal")) \
            + geom_violin(aes(fill="langconstr")) \
            + ylim(0, 1)
    #            %+ geom_signif(map_signif_level=True, textsize = 2)
    vplot.save(fname, dpi=300)


def violin_correct(df, fname):
    vplot = ggplot(df, aes(x="langconstr", y="correct")) \
            + geom_violin(aes(fill="langconstr")) \
        #            %+ geom_signif(map_signif_level=True, textsize = 2)
    vplot.save(fname, dpi=300)


def plot_correcttop10(df, fname):
    sns.barplot(x="langconstr", y="target_in_top10", data=df)
    plt.savefig(fname)

