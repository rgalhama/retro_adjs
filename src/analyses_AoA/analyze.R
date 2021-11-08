library(glue)
library(ggplot2)
library(ggsignif)
library(ggpubr)

measure="produces"
lexical_class="adjectives"
proportion=0.5

lang="ita"
fname=glue("aoa_wordbank_{lang}_{measure}_prop{proportion}_{lexical_class}_clean_means.csv")
ita=read.csv(fname, sep=";")
lang="eng"
fname=glue("aoa_wordbank_{lang}_{measure}_prop{proportion}_{lexical_class}_clean_means.csv")
eng=read.csv(fname, sep=";")


t.test(ita$aoa, eng$aoa, alternative = "two.sided", var.equal = FALSE)
#t = 0.64789, df = 46.03, p-value = 0.5203
#nouns: t = -0.037811, df = 302.7, p-value = 0.9699

boxplot(eng$aoa, ita$aoa, names=c("English", "Italian"))

#There is more variability in Italian, although the means are surprisingly similar.
#If we could annotate the dataset with the most common position for each adjective (prenominal or postnominal), we
#could see if the AoA depends on it (though it may depend also on frequency; we could add it to the analyses as well)

eng_adj <- read.csv("aoa_wordbank_eng_produces_prop0.5_adjectives_clean_means.csv", sep= ";", header=TRUE)
eng_noun <- read.csv("aoa_wordbank_eng_produces_prop0.5_nouns_clean_means.csv", sep= ";", header=TRUE)
ita_adj <- read.csv("aoa_wordbank_ita_produces_prop0.5_adjectives_clean_means.csv", sep= ";", header=TRUE)
ita_noun <- read.csv("aoa_wordbank_ita_produces_prop0.5_nouns_clean_means.csv", sep= ";", header=TRUE)

eng_adj$lang = 'English'
eng_noun$lang = 'English'
ita_adj$lang = 'Italian'
ita_noun$lang = 'Italian'

# rename one column of ita_adj dataframe to be able to bind them
names(ita_adj)[names(ita_adj) == "definition"] <- "uni_lemma"
names(ita_noun)[names(ita_noun) == "definition"] <- "uni_lemma"

aoa_adj = rbind(eng_adj, ita_adj)
aoa_noun = rbind(eng_noun, ita_noun)

# aoa adjectives
p1 <- ggplot(aoa_adj, aes (x = lang, y = aoa))
bp1 <- p1 + geom_boxplot(aes(fill=lang))+
    scale_fill_manual(values = c("#999999", "#E69F00"))+
    scale_x_discrete(limits=c("Italian", "English"))+
    geom_signif(comparisons = list(c("Italian", "English")), map_signif_level=TRUE)+
    ggtitle("Adjectives")+
    theme(legend.position = "none")+
    xlab('Language')+
    ylab('Age of acquisition (months)')+
    ylim(19,37)+
    theme(text = element_text(size = 16)) 
    ggsave("aoa_adj.png")
bp1

# aoa nouns
p2 <- ggplot(aoa_noun, aes (x = lang, y = aoa))
bp2 <- p2 + geom_boxplot(aes(fill=lang))+
    scale_fill_manual(values = c("#999999", "#E69F00"))+
    scale_x_discrete(limits=c("Italian", "English"))+
    geom_signif(comparisons = list(c("Italian", "English")), map_signif_level=TRUE)+
    ggtitle("Nouns")+
    theme(legend.position = "none")+
    xlab('Language')+
    ylab('Age of acquisition (months)')+
    ylim(19,37)+
    theme(text = element_text(size = 16)) 
    ggsave("aoa_nouns.png")
bp2

aoa_figure <- ggarrange(bp1,bp2, ncol = 2, nrow = 1)+
    ggsave("aoa_adjs_nouns.png")
aoa_figure
