library(ggplot2)

setwd("predictions_nns/")

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
model_eng_d1_seed745_allepochs = rbind(model_eng_1delay_seed745_epoch10, model_eng_1delay_seed745_epoch20,
                                       model_eng_1delay_seed745_epoch30, model_eng_1delay_seed745_epoch40,
                                       model_eng_1delay_seed745_epoch50, model_eng_1delay_seed745_epoch60,
                                       model_eng_1delay_seed745_epoch70, model_eng_1delay_seed745_epoch80,
                                       model_eng_1delay_seed745_epoch90, model_eng_1delay_seed745_epoch100,
                                       model_eng_1delay_seed745_epoch200, model_eng_1delay_seed745_epoch300,
                                       model_eng_1delay_seed745_epoch400)


df = model_eng_d1_seed745_allepochs


# line graph of entropy timecourse
p1 <- ggplot(df, aes(x=epoch, y=entropy))
lp <- p1 + geom_line(color="#999999")+
  geom_point(color="#999999")+
  xlab("Epochs")+
  ylab("Entropy")
lp