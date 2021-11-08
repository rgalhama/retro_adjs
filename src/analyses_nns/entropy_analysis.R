library(ggplot2)
library(ggsignif)
library(ggpubr)

# import dataframes
model_eng_bw <- read.csv("model_eng_backward_seed_2343_epoch_58_accuracies_test.csv", sep= ",", header=TRUE)
model_eng_fw <- read.csv("model_eng_forward_seed_2342_epoch_67_accuracies_test.csv", sep=",", header=TRUE)
model_ita_bw <- read.csv("model_ita_backward_seed_2343_epoch_78_accuracies_test.csv", sep=",", header=TRUE)
model_ita_fw <- read.csv("model_ita_forward_seed_2342_epoch_62_accuracies_test.csv", sep=",", header=TRUE)

# import accuracy files for all epochs Delay1-RNN English
model_eng_1delay_seed745_epoch10 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_10.csv", sep=",", header=TRUE)
model_eng_1delay_seed745_epoch20 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_20.csv", sep=",", header=TRUE)
model_eng_1delay_seed745_epoch30 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_30.csv", sep=",", header=TRUE)
model_eng_1delay_seed745_epoch40 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_40.csv", sep=",", header=TRUE)
model_eng_1delay_seed745_epoch50 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_50.csv", sep=",", header=TRUE)
model_eng_1delay_seed745_epoch60 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_60.csv", sep=",", header=TRUE)
model_eng_1delay_seed745_epoch70 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_70.csv", sep=",", header=TRUE)
model_eng_1delay_seed745_epoch80 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_80.csv", sep=",", header=TRUE)
model_eng_1delay_seed745_epoch90 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_90.csv", sep=",", header=TRUE)
model_eng_1delay_seed745_epoch100 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_100.csv", sep=",", header=TRUE)
model_eng_1delay_seed745_epoch200 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_200.csv", sep=",", header=TRUE)
model_eng_1delay_seed745_epoch300 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_300.csv", sep=",", header=TRUE)
model_eng_1delay_seed745_epoch400 <- read.csv("accuracies_test_eng_forward_1delay_seed_745_epoch_400.csv", sep=",", header=TRUE)

# add epoch column to dataframes
model_eng_1delay_seed745_epoch10$epoch = '10'
model_eng_1delay_seed745_epoch20$epoch = '20' 
model_eng_1delay_seed745_epoch30$epoch = '30' 
model_eng_1delay_seed745_epoch40$epoch = '40'
model_eng_1delay_seed745_epoch50$epoch = '50'
model_eng_1delay_seed745_epoch60$epoch = '60'
model_eng_1delay_seed745_epoch70$epoch = '70'
model_eng_1delay_seed745_epoch80$epoch = '80'
model_eng_1delay_seed745_epoch90$epoch = '90'
model_eng_1delay_seed745_epoch100$epoch = '100'
model_eng_1delay_seed745_epoch200$epoch = '200'
model_eng_1delay_seed745_epoch300$epoch = '300'
model_eng_1delay_seed745_epoch400$epoch = '400'

# combine all dataframes in one dataframe
model_eng_d1 = rbind(model_eng_1delay_seed745_epoch10, model_eng_1delay_seed745_epoch20,
                                       model_eng_1delay_seed745_epoch30, model_eng_1delay_seed745_epoch40,
                                       model_eng_1delay_seed745_epoch50, model_eng_1delay_seed745_epoch60,
                                       model_eng_1delay_seed745_epoch70, model_eng_1delay_seed745_epoch80,
                                       model_eng_1delay_seed745_epoch90, model_eng_1delay_seed745_epoch100,
                                       model_eng_1delay_seed745_epoch200, model_eng_1delay_seed745_epoch300,
                                       model_eng_1delay_seed745_epoch400)

# same for Italian Delay-RNN
model_ita_1delay_seed744_epoch10 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_10.csv", sep=",", header=TRUE)
model_ita_1delay_seed744_epoch20 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_20.csv", sep=",", header=TRUE)
model_ita_1delay_seed744_epoch30 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_30.csv", sep=",", header=TRUE)
model_ita_1delay_seed744_epoch40 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_40.csv", sep=",", header=TRUE)
model_ita_1delay_seed744_epoch50 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_50.csv", sep=",", header=TRUE)
model_ita_1delay_seed744_epoch60 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_60.csv", sep=",", header=TRUE)
model_ita_1delay_seed744_epoch70 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_70.csv", sep=",", header=TRUE)
model_ita_1delay_seed744_epoch80 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_80.csv", sep=",", header=TRUE)
model_ita_1delay_seed744_epoch90 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_90.csv", sep=",", header=TRUE)
model_ita_1delay_seed744_epoch100 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_100.csv", sep=",", header=TRUE)
model_ita_1delay_seed744_epoch200 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_200.csv", sep=",", header=TRUE)
model_ita_1delay_seed744_epoch300 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_300.csv", sep=",", header=TRUE)
model_ita_1delay_seed744_epoch400 <- read.csv("accuracies_test_ita_forward_1delay_seed_744_epoch_400.csv", sep=",", header=TRUE)

# add epoch colum
# add language column to dataframes
model_ita_1delay_seed744_epoch10$epoch = '10'
model_ita_1delay_seed744_epoch20$epoch = '20' 
model_ita_1delay_seed744_epoch30$epoch = '30' 
model_ita_1delay_seed744_epoch40$epoch = '40'
model_ita_1delay_seed744_epoch50$epoch = '50'
model_ita_1delay_seed744_epoch60$epoch = '60'
model_ita_1delay_seed744_epoch70$epoch = '70'
model_ita_1delay_seed744_epoch80$epoch = '80'
model_ita_1delay_seed744_epoch90$epoch = '90'
model_ita_1delay_seed744_epoch100$epoch = '100'
model_ita_1delay_seed744_epoch200$epoch = '200'
model_ita_1delay_seed744_epoch300$epoch = '300'
model_ita_1delay_seed744_epoch400$epoch = '400'

# combine all dataframes in one dataframe
model_ita_d1 = rbind(model_ita_1delay_seed744_epoch10, model_ita_1delay_seed744_epoch20,
                     model_ita_1delay_seed744_epoch30, model_ita_1delay_seed744_epoch40,
                     model_ita_1delay_seed744_epoch50, model_ita_1delay_seed744_epoch60,
                     model_ita_1delay_seed744_epoch70, model_ita_1delay_seed744_epoch80,
                     model_ita_1delay_seed744_epoch90, model_ita_1delay_seed744_epoch100,
                     model_ita_1delay_seed744_epoch200, model_ita_1delay_seed744_epoch300,
                     model_ita_1delay_seed744_epoch400)


# add language column to all dataframes
model_eng_bw$lang='English'
model_eng_fw$lang='English'
model_ita_bw$lang='Italian'
model_ita_fw$lang='Italian'
model_eng_d1$lang='English'
model_ita_d1$lang='Italian'

# add extra column for direction of the model
model_eng_bw$direction='Backward'
model_eng_fw$direction='Forward'
model_ita_bw$direction='Backward'
model_ita_fw$direction='Forward'
model_eng_d1$direction='Delay-RNN'
model_ita_d1$direction='Delay-RNN'

# The filters are:
#   
# English (adj-noun), Fw and Delay-RNN:
#   actual_tag=ADJ JJ and next_tag=NOUN
eng_AN_fw = ((model_eng_fw$actual_pos=='ADJ JJ') & (model_eng_fw$next_tag=='NOUN NN'))
model_eng_fw_AdjN = model_eng_fw[eng_AN_fw,]

# 
# English (adj-noun), Bw:
#   actual_tag=NOUN and next_tag=ADJ JJ
eng_AN_bw = ((model_eng_bw$actual_pos=='NOUN NN') & (model_eng_bw$next_tag=='ADJ JJ'))
model_eng_bw_AdjN = model_eng_bw[eng_AN_bw,]
# 
# Italian (combined), Fw, Bw and Delay-RNN:
#   
#   (actual_tag=ADJ JJ and next_tag=NOUN) or (actual_tag=NOUN and next_tag=ADJ JJ)
ita_combined_fw = ((model_ita_fw$actual_pos=='ADJ JJ') & (model_ita_fw$next_tag=='NOUN NN') |
                   (model_ita_fw$actual_pos=='NOUN NN') & (model_ita_fw$next_tag=='ADJ JJ'))
model_ita_fw_combined = model_ita_fw[ita_combined_fw,]
ita_combined_bw = ((model_ita_bw$actual_pos=='ADJ JJ') & (model_ita_bw$next_tag=='NOUN NN') |
                     (model_ita_bw$actual_pos=='NOUN NN') & (model_ita_bw$next_tag=='ADJ JJ'))
model_ita_bw_combined = model_ita_bw[ita_combined_bw,]
# 
# 
# Italian (noun-adj), Fw and Delay-RNN:
#   actual_tag=NOUN and next_tag=ADJ JJ
ita_NA_fw = ((model_ita_fw$actual_pos=='NOUN NN')&(model_ita_fw$next_tag=='ADJ JJ'))
model_ita_fw_NAdj = model_ita_fw[ita_NA_fw,]

# Italian(noun-adj), Bw:
#   actual_tag=ADJ JJ and next_tag=NOUN
ita_NA_bw = ((model_ita_bw$actual_pos=='ADJ JJ')&(model_ita_bw$next_tag=='NOUN NN'))
model_ita_bw_NAdj = model_ita_bw[ita_NA_bw,]
# 
# Italian(adj-noun), Fw and Delay-RNN:
#   actual_tag=ADJ JJ and next_tag=NOUN
ita_AN_fw = ((model_ita_fw$actual_pos=='ADJ JJ')&(model_ita_fw$next_tag=='NOUN NN'))
model_ita_fw_AdjN = model_ita_fw[ita_AN_fw,]
# Italian(adj-noun), Bw:
#   actual_tag=NOUN and next_tag=ADJ JJ
ita_AN_bw = ((model_ita_bw$actual_pos=='NOUN NN')&(model_ita_bw$next_tag=='ADJ JJ'))
model_ita_bw_AdjN = model_ita_bw[ita_AN_bw,]

# add order column to Italian AdjN and NAdj dataframes
model_ita_fw_AdjN$order='Adjective-Noun'
model_ita_bw_AdjN$order='Adjective-Noun'
model_ita_fw_NAdj$order='Noun-Adjective'
model_ita_bw_NAdj$order='Noun-Adjective'

# create plots for entropy
model_ita_combined = rbind(model_ita_fw_combined, model_ita_bw_combined)
p1 <- ggplot(model_ita_combined, aes (x = direction, y = entropy))
bp1 <- p1 + geom_boxplot(aes(fill=lang))+
  scale_fill_manual(values = "#E69F00")+
  scale_x_discrete(limits=c("Forward", "Backward"))+
  geom_signif(comparisons = list(c("Forward", "Backward")), map_signif_level=TRUE, textsize = 2)+
  facet_wrap(~lang)+
  theme(legend.position = "none")+
  xlab('Direction')+
  ylab('Entropy')+
  ggsave("entropy_models_ita_combined.png")
bp1

model_eng = rbind(model_eng_fw_AdjN, model_eng_bw_AdjN)
p2 <- ggplot(model_eng, aes (x = direction, y = entropy))
bp2 <- p2 + geom_boxplot(aes(fill=lang))+
  scale_fill_manual(values = "#999999")+
  scale_x_discrete(limits=c("Forward", "Backward"))+
  geom_signif(comparisons = list(c("Forward", "Backward")), map_signif_level=TRUE, textsize = 2)+
  facet_wrap(~lang)+
  theme(legend.position = "none")+
  xlab('Direction')+
  ylab('Entropy')+
  ggsave("entropy_models_eng_AdjN.png")
bp2

model_ita_AdjN = rbind(model_ita_fw_AdjN, model_ita_bw_AdjN)
p3 <- ggplot(model_ita_AdjN, aes (x = direction, y = entropy))
bp3 <- p3 + geom_boxplot(aes(fill=lang))+
  scale_fill_manual(values = "#E69F00")+
  scale_x_discrete(limits=c("Forward", "Backward"))+
  geom_signif(comparisons = list(c("Forward", "Backward")), map_signif_level=TRUE, textsize = 2)+
  facet_wrap(~order)+
  theme(strip.text = element_text(lineheight=3.0))+
  theme(legend.position = "none")+
  xlab('Direction')+
  ylab('Entropy')+
  ggsave("entropy_models_ita_AdjN.png")
bp3

model_ita_NAdj = rbind(model_ita_fw_NAdj, model_ita_bw_NAdj)
p4 <- ggplot(model_ita_NAdj, aes (x = direction, y = entropy))
bp4 <- p4 + geom_boxplot(aes(fill=lang))+
  scale_fill_manual(values = "#E69F00")+
  scale_x_discrete(limits=c("Forward", "Backward"))+
  geom_signif(comparisons = list(c("Forward", "Backward")), map_signif_level=TRUE, textsize = 2)+
  facet_wrap(~order)+
  theme(strip.text = element_text(lineheight=3.0))+
  theme(legend.position = "none")+
  xlab('Direction')+
  ylab('Entropy')+
  ggsave("entropy_models_ita_NAdj.png")
bp4

figure2_allmodels <- ggarrange(bp1,bp2,bp3,bp4,
                              ncol = 2, nrow = 2)+
  ggsave("figure2_with_AN_NA_ita.png")
figure2_allmodels

# mean and sd

# Italian
# combined Fw:
mean(model_ita_fw_combined$entropy)
sd(model_ita_fw_combined$entropy)

# combined Bw:
mean(model_ita_bw_combined$entropy)
sd(model_ita_bw_combined$entropy)

# noun-adj Fw:
mean(model_ita_fw_NAdj$entropy)
sd(model_ita_fw_NAdj$entropy)

# noun-adj Bw:
mean(model_ita_bw_NAdj$entropy)
sd(model_ita_bw_NAdj$entropy)

# adj-noun Fw:
mean(model_ita_fw_AdjN$entropy)
sd(model_ita_fw_AdjN$entropy)

# adj-noun Bw:
mean(model_ita_bw_AdjN$entropy)
sd(model_ita_bw_AdjN$entropy)

# English
# Fw:
mean(model_eng_fw_AdjN$entropy)
sd(model_eng_fw_AdjN$entropy)

# Bw:
mean(model_eng_bw_AdjN$entropy)
sd(model_eng_bw_AdjN$entropy)
