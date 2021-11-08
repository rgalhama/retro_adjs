#!/usr/bin/Rscript

# Extracts Age of Acquisition data from Wordbank
# Example usage: extract_AoA_wordbank.R "ita" "Italian" "adjectives"
# Output: instrument files (intermediate files); csv file with words and estimated AoA

# The R API:
# https://langcog.github.io/wordbankr/


#Load libraries
library(wordbankr)
library(magrittr) # need to run every time you start R and want to use %>%
library(glue)
library(dplyr)    # alternative, this also loads %>%
library(optparse)


#Fixed options
measure="produces" #we are interested in production of adjectives, as production reflects word-order acquisition (while comprehension may not)
proportion=0.5 #standard value for establishing acquisition

#Default params
#lang="ita"
#language="Italian"
#lexical_class="adjectives"

# Read params
option_list = list(
  make_option("--lang", type="character", default=NULL,
              help="ita/eng"),
  make_option("--language", type="character", default=NULL, help="Full name of language"),
  make_option("--lexical_class", type="character", default=NULL, help="Lexical class (adjectives/nouns)")
);

opt_parser <- OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

lang=opt$lang
language=opt$language
lexical_class=opt$lexical_class


#######################
# PATHS AND FILENAMES #
#######################
instr_dir=glue("~/Data_Research/wordbank/instrument_data/{tolower(language)}/")
output_fname=glue("aoa_wordbank_{lang}_{measure}_prop{proportion}_{lexical_class}.csv")
setwd("~/ownCloud/LearningAdjs/project_adjs/data_preparation/AoA/")
#######################


#Source Wordbank library
source("Wordbank_estimation_AoA.R")


#Find target words of the language
all_items <- get_item_data()
lang_items <- all_items[grep(language, all_items$language),]
#sdf=lang_items[,1:2]
dialects=unique(lang_items$language)
forms=unique(lang_items$form)
items_ids=lang_items$item_id
rm(all_items) #save memory
#items <- get_item_data(language, form)$item_id


#Load an instrument
#  form: WS: Words and Sentences / WG: Words and Gestures
#all available forms (WS/WG) are used
#  type: phrases, words, ...
#  lexical_category: nouns, ...
try(rm(df))
for (dialect in dialects){
    for (form in forms){
        # Remove TED forms (they are for twins, who can show different developmental trajectories)
        if (! grepl('^TEDS', form) && !grepl("WG", form)){ #
            print(glue(dialect," ",form))
            try(df<-get_instrument_data(dialect,form, administrations=TRUE, iteminfo = TRUE))
            fname=glue("{instr_dir}/instrument_data_wordbank_{dialect}_{form}.csv")
            if (exists('df')){
                try(write.table(df, fname, sep=";", quote = FALSE, col.names = TRUE, row.names = FALSE, fileEncoding = 'utf-8'))
                try(rm(df))
            }
        }
}}

#combined_data <- rbind(data,data2)


#Load instrument data from the directory and bind
filenames <- list.files(instr_dir, full.names = TRUE)
fulldata <- Reduce(rbind, lapply(filenames, read.csv, sep=";"))

#Filter by type, if specified
if (lexical_class != ""){
    data <-fulldata[grep(lexical_class, fulldata$lexical_class),]
}else{
    data <-fulldata
}
rm(fulldata)

#Estimate AoA:
#The AoA is estimated by computing the proportion of administrations for which 
#the child understands/produces (measure) each word, 
#smoothing the proportion using method, 
#and taking the age at which the smoothed value is greater than proportion.
#Params:
#measure: understands, produces
#method: glmrob, ?
#proportion: 0 <= prop <= 1
print("Predicting AoA of words...:")
aoa=fit_aoa(data, measure = measure, method = "glmrob", proportion = proportion)

#Remove NA
aoa <- aoa[!is.na(aoa$aoa),]
aoa <- aoa[!is.na(aoa$uni_lemma),]

#This is not needed, since the column of interest is uni_lemma
#aoa %>%
#mutate(definition = str_replace(definition, '(.*$',""))

#Output
write.table(aoa, output_fname, sep=";", quote = FALSE, col.names = TRUE, row.names = FALSE, fileEncoding = 'utf-8') 

#See min and max AoA in this language
min(aoa$aoa)
max(aoa$aoa)
















