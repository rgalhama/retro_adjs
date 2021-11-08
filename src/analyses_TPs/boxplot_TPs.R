library(ggplot2)
library(ggsignif)
library(ggpubr)

# to install ggsignif
# use: install.packages("ggsignif")
# package info: https://cran.r-project.org/web/packages/ggsignif/ggsignif.pdf
# URL https://github.com/const-ae/ggsignif

itaAN <- read.csv("ita_AdjNoun_tps.csv", sep= ";", header=TRUE)
itaNA <- read.csv("ita_NounAdj_tps.csv", sep=";", header=TRUE)
itaAll <- read.csv("ita_tps.csv", sep=";", header=TRUE)
engAN <- read.csv("eng_AdjNoun_tps.csv", sep=";", header=TRUE)
engNA <- read.csv("eng_NounAdj_tps.csv", sep=";", header=TRUE)
engAll <- read.csv("eng_tps.csv", sep=";", header=TRUE)

all <- rbind(itaAll, engAll)

# how to have fw and bw not alphabetically sorted out?
# itaNA$names <- factor(itaNA$names , levels=c("fw", "bw"))

# creat an extra column with full language name (i.e. Italian, English)
itaAN$fulllang='Italian'
itaNA$fulllang='Italian'
engAN$fulllang='English'


# Single boxplots with significance level

# ita noun-adj
bp1 <- ggplot(itaNA, aes(x=direction, y=prob, fill=lang)) 
bp_ita_NA <- bp1 +  geom_boxplot() +
  ggtitle("Noun-Adjective")+
  theme(plot.title = element_text(size = 12))+
  scale_fill_manual(values = "#E69F00", name = "Language", label = "Italian")+
  scale_x_discrete(limits=c("fw", "bw"), labels = c("fw"="Forward", "bw"="Backward"))+ #change the default order of the items
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE, textsize = 3)+ #show significance level
  xlab('Direction')+
  ylab('Probability')+
  facet_wrap(~fulllang)+
  theme(strip.text = element_text(lineheight=3.0))+
  theme(legend.position = "none")+
  ylim(0,1.25)+
  ggsave("ita_NA_rplot.png", width = 16, height = 9, dpi = 100)
bp_ita_NA

# ita adj-noun
bp2 <- ggplot(itaAN, aes(x=direction, y=prob, fill=lang))
bp_ita_AN <- bp2 +  geom_boxplot() +
  ggtitle("Adjective-Noun") +
  theme(plot.title = element_text(size = 12))+
  scale_fill_manual(values = "#E69F00",  name = "Language", label = "Italian")+
  scale_x_discrete(limits=c("fw", "bw"), labels = c("fw"="Forward", "bw"="Backward"))+
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE)+ #show significance level
  xlab('Direction')+
  ylab('Probability')+
  facet_wrap(~fulllang)+
  theme(strip.text = element_text(lineheight=3.0))+
  theme(legend.position = "none")+
  ylim(0,1.25)+
  ggsave("ita_AN_rplot.png", width = 16, height = 9, dpi = 100)
bp_ita_AN

# eng noun-adj
ggplot(engNA, aes(x=direction, y=prob, fill=lang)) + 
  geom_boxplot() +
  ggtitle("English Noun-Adjective") +
  scale_fill_manual(values = "#999999")+
  scale_x_discrete(limits=c("fw", "bw"), labels = c("fw"="Forward", "bw"="Backward"))+
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE)+ #show significance level
  xlab('Direction')+
  ylab('Probability')+
  ggsave("graphs/violinplots/eng_NA_rplot.png")

# eng adj-noun
bp3 <- ggplot(engAN, aes(x=direction, y=prob, fill=lang))
bp_eng_AN <- bp3 +  geom_boxplot() +
  ggtitle("Adjective-Noun") +
  theme(plot.title = element_text(size = 12))+
  scale_fill_manual(values = "#999999",  name = "Language", label = "English")+
  scale_x_discrete(limits=c("fw", "bw"), labels = c("fw"="Forward", "bw"="Backward"))+
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE)+ #show significance level
  xlab('Direction')+
  ylab('Probability')+
  facet_wrap(~fulllang)+
  theme(strip.text = element_text(lineheight=3.0))+
  theme(legend.position = "none")+
  ylim(0,1.25)+
  ggsave("graphs/violinplots/eng_AN_rplot.png", width = 16, height = 9, dpi = 100)
bp_eng_AN

# Merge three boxplot (ita_AN, ita_NA, eng_AN)
figure <- ggarrange(bp_ita_AN, bp_ita_NA, bp_eng_AN,
                    ncol = 2, nrow = 2)+
  ggsave("figure1.png")
figure


# Multiple groups boxplot inspired by:
# http://www.sthda.com/english/articles/32-r-graphics-essentials/132-plot-grouped-data-box-plot-bar-plot-and-more/
# merge ita + eng adj-n
adj_n <- rbind(itaAN, engAN)

# Default plot
p <- ggplot(adj_n, aes(x = direction, y = prob))
p + geom_boxplot()+
  scale_x_discrete(limits=c("fw", "bw"))+ #change the default order of the items
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE)+
  xlab('Direction')+
  ylab('Probability')

# Plot with multiple groups
p2 <- p + geom_boxplot(
  aes(fill = lang),
  position = position_dodge(0.9) ) +
  scale_fill_manual(values = c("#999999", "#E69F00"), name = "Language", labels = c("English", "Italian"))+
  scale_x_discrete(limits=c("fw", "bw"))+
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE)+
  xlab('Direction')+
  ylab('Probability')+
  ggsave("graphs/violinplots/AN_rplot.png")
p2

# merge ita + eng n-adj
n_adj <- rbind(itaNA, engNA)

# plot ita + eng n-adj
p3 <- ggplot(n_adj, aes(x = direction, y = prob))
p3 + geom_boxplot()+
  scale_x_discrete(limits=c("fw", "bw"))+ #change the default order of the items
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE)+
  xlab('Direction')+
  ylab('Probability')

# Plot with multiple groups
p4 <- p3 + geom_boxplot(
  aes(fill = lang),
  position = position_dodge(0.9) 
) +
  scale_fill_manual(values = c("#999999", "#E69F00"), name = "Language", labels = c("English", "Italian"))+
  scale_x_discrete(limits=c("fw", "bw"))+
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE)+
  xlab('Direction')+
  ylab('Probability')+
  ggsave("NA_rplot.png")
p4


# Plot all dataframes
p5 <- ggplot(all, aes(x = direction, y = prob))
p5 + geom_boxplot()+
  scale_x_discrete(limits=c("fw", "bw"))+ #change the default order of the items
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE)+
  xlab('Direction')+
  ylab('Probability')

# Plot with multiple groups
p6 <- p5 + geom_boxplot(
  aes(fill = lang),
  position = position_dodge(0.9) 
) +
  scale_fill_manual(values = c("#999999", "#E69F00"), name = "Language", labels = c("English", "Italian"))+
  scale_x_discrete(limits=c("fw", "bw"))+
  geom_signif(comparisons = list(c("fw", "bw")), map_signif_level=TRUE)+
  xlab('Direction')+
  ylab('Probability')+
  ggsave("all_rplot.png")
p6


# Plot fw-ita vs. fw-eng and bw-ita vs. bw-eng, in both orders

v1 = adj_n$direction == 'fw'
v2 = adj_n$direction == 'bw'
v3 = n_adj$direction == 'fw'
v4 = n_adj$direction == 'bw'

adj_n_fw = adj_n[v1,]
adj_n_bw = adj_n[v2,]
n_adj_fw = n_adj[v3,]
n_adj_bw = n_adj[v4,]

p7 <- ggplot(adj_n_fw, aes (x = lang, y = prob))
p7 + geom_boxplot(aes(fill=lang))+
  scale_fill_manual(values = c("#999999", "#E69F00"))+
  scale_x_discrete(limits=c("ita", "eng"), labels = c("ita"="Italian", "eng"="English"))+
  geom_signif(comparisons = list(c("ita", "eng")), map_signif_level=TRUE)+
  facet_wrap(~direction)+
  theme(legend.position = "none")+
  xlab('Language')+
  ylab('Probability')+
  ggsave("AN_fw_rplot.png")

p8 <- ggplot(adj_n_bw, aes (x = lang, y = prob))
p8 + geom_boxplot(aes(fill=lang))+
  scale_fill_manual(values = c("#999999", "#E69F00"))+
  scale_x_discrete(limits=c("ita", "eng"), labels = c("ita"="Italian", "eng"="English"))+
  geom_signif(comparisons = list(c("ita", "eng")), map_signif_level=TRUE)+
  facet_wrap(~direction)+
  theme(legend.position = "none")+
  xlab('Language')+
  ylab('Probability')+
  ggsave("AN_bw_rplot.png")

p9 <- ggplot(n_adj_fw, aes (x = lang, y = prob))
p9 + geom_boxplot(aes(fill=lang))+
  scale_fill_manual(values = c("#999999", "#E69F00"))+
  scale_x_discrete(limits=c("ita", "eng"), labels = c("ita"="Italian", "eng"="English"))+
  geom_signif(comparisons = list(c("ita", "eng")), map_signif_level=TRUE)+
  facet_wrap(~direction)+
  theme(legend.position = "none")+
  xlab('Language')+
  ylab('Probability')+
  ggsave("NA_fw_rplot.png")

p10 <- ggplot(n_adj_bw, aes (x = lang, y = prob))
p10 + geom_boxplot(aes(fill=lang))+
  scale_fill_manual(values = c("#999999", "#E69F00"))+
  scale_x_discrete(limits=c("ita", "eng"), labels = c("ita"="Italian", "eng"="English"))+
  geom_signif(comparisons = list(c("ita", "eng")), map_signif_level=TRUE)+
  facet_wrap(~direction)+
  theme(legend.position = "none")+
  xlab('Language')+
  ylab('Probability')+
  ggsave("NA_bw_rplot.png")

