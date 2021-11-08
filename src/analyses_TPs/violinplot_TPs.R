# use: install.packages("ggsignif")
# package info: https://cran.r-project.org/web/packages/ggsignif/ggsignif.pdf
# URL https://github.com/const-ae/ggsignif

library(ggplot2)
library(ggsignif)
library(ggpubr)
library(glue)

# Set working directory to source file directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Modes (eng300 is for fixed number of adjectives; "" is for fixed number of sentences)
mode="eng300_"

# Load data
itaAN <- read.csv("ita_AdjNoun_tps.csv", sep= ";", header=TRUE)
itaNA <- read.csv("ita_NounAdj_tps.csv", sep=";", header=TRUE)
itaAll <- read.csv("ita_tps.csv", sep=";", header=TRUE)
engAN <- read.csv(glue("{mode}eng_AdjNoun_tps.csv"), sep=";", header=TRUE)
engNA <- read.csv("eng_NounAdj_tps.csv", sep=";", header=TRUE)
engAll <- read.csv(glue("{mode}eng_tps.csv"), sep=";", header=TRUE)

all <- rbind(itaAll, engAll)
itaAll <- rbind(itaAN, itaNA)

# how to have fw and bw not alphabetically sorted out?
# itaNA$names <- factor(itaNA$names , levels=c("fw", "bw"))

# creat an extra column with full language name (i.e. Italian, English)
itaAN$fulllang='Italian'
itaNA$fulllang='Italian'
engAN$fulllang='English'

# Aesthetics
textsize=16
myTheme = theme(
  axis.title.x = element_text(size = textsize),
  axis.text.x = element_text(size = textsize-2),
  axis.title.y = element_text(size = textsize), 
  strip.text = element_text(size = textsize) #for facetwrap (language)
)


# Single boxplots with significance level

# ita noun-adj
bp1 <- ggplot(itaNA, aes(x=direction, y=prob, fill=lang)) 
bp_ita_NA <- bp1  +
  geom_violin(draw_quantiles = c(0.5) )+
  ggtitle("Noun-Adjective")+
  theme(plot.title = element_text(size = textsize))+
  scale_fill_manual(values = "#E69F00", name = "Language", label = "Italian")+
  scale_x_discrete(limits=c("fw", "bw"), labels = c("fw"="Forward", "bw"="Backward"))+ #change the default order of the items
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE, textsize = 3)+ #show significance level
  xlab('Direction')+
  ylab('Distribution of Conditional Probabilities')+
  facet_wrap(~fulllang)+
  theme(strip.text = element_text(lineheight=3.0))+
  theme(legend.position = "none")+
  ylim(0,1.1)+
  myTheme +
  ggsave("ita_NA_rplot.png", width = 8, height = 9, dpi = 100)
bp_ita_NA

# ita adj-noun
bp2 <- ggplot(itaAN, aes(x=direction, y=prob, fill=lang))
bp_ita_AN <- bp2 +  geom_violin(draw_quantiles = c(0.5)) +
  ggtitle("Adjective-Noun") +
  theme(plot.title = element_text(size = textsize))+
  scale_fill_manual(values = "#E69F00",  name = "Language", label = "Italian")+
  scale_x_discrete(limits=c("fw", "bw"), labels = c("fw"="Forward", "bw"="Backward"))+
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE)+ #show significance level
  xlab('Direction')+
  ylab('Distribution of Conditional Probabilities')+
  facet_wrap(~fulllang)+
  theme(strip.text = element_text(lineheight=3.0))+
  theme(legend.position = "none")+
  ylim(0,1.1)+
  myTheme +
  ggsave("ita_AN_rplot.png", width = 8, height = 9, dpi = 100)
bp_ita_AN

# eng noun-adj
ggplot(engNA, aes(x=direction, y=prob, fill=lang)) + 
  geom_violin(draw_quantiles = c(0.5) )+
  ggtitle("English Noun-Adjective") +
  scale_fill_manual(values = "#999999")+
  scale_x_discrete(limits=c("fw", "bw"), labels = c("fw"="Forward", "bw"="Backward"))+
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE)+ #show significance level
  xlab('Direction')+
  ylab('Distribution of Conditional Probabilities')+
  ggsave(glue("{mode}eng_NA_rplot.png"))

# eng adj-noun
bp3 <- ggplot(engAN, aes(x=direction, y=prob, fill=lang))
bp_eng_AN <- bp3 +
  geom_violin(draw_quantiles = c(0.5) )+
  ggtitle("Adjective-Noun") +
  theme(plot.title = element_text(size =textsize))+
  scale_fill_manual(values = "#999999",  name = "Language", label = "English")+
  scale_x_discrete(limits=c("fw", "bw"), labels = c("fw"="Forward", "bw"="Backward"))+
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE)+ #show significance level
  xlab('Direction')+
  ylab('Distribution of Conditional Probabilities')+
  facet_wrap(~fulllang)+
  theme(strip.text = element_text(lineheight=3.0))+
  theme(legend.position = "none")+
  ylim(0,1.1)+
  myTheme
  ggsave(glue("{mode}eng_AN_rplot.png"), width = 8, height = 9, dpi = 100)
bp_eng_AN

# Merge three boxplot (ita_AN, ita_NA, eng_AN)
figure <- ggarrange(bp_ita_AN, bp_ita_NA, bp_eng_AN,
                    ncol = 3, nrow = 1)+ myTheme +
  ggsave(glue("{mode}violinplot_per_lang_per_construction.png"))
figure

# Merge only Italian constructions
figure <- ggarrange(bp_ita_AN, bp_ita_NA, 
                    ncol = 2, nrow = 1)+ myTheme +
  ggsave(glue("{mode}violinplot_Italian_per_construction.png"))
figure

