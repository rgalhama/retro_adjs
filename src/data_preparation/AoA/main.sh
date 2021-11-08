#!/usr/bin/env bash

main () {

  lang=$1
  language=$2
  category=$3

  ##### EXTRACT DATA ####
  #1. call R script extract_AoA_wordbank.R (the following code has not been tested yet)
  ./extract_AoA_wordbank.R --lang $lang --language $language --lexical_class $category


  #### CLEAN THE EXTRACTED DATA ####
  input_file="aoa_wordbank_${lang}_produces_prop0.5_${category}.csv"
  clean_file=`echo $input_file | sed 's/.csv/_clean.csv/'`

  #Column: definition
  cat $input_file | awk 'BEGIN{FS=";"}{sub(/ ?\(.*/,"",$4); sub(/ ?\/.*/,"",$4);print $0}' OFS=";" >  aux

  #Column: uni_lemma
  cat aux| awk 'BEGIN{FS=";"}{sub(/ ?\(.*/,"",$9); sub(/ ?\/.*/,"",$9);print $0}' OFS=";" >  $clean_file

  rm aux

  ###### COMBINE REPETITIONS ######
  #################################
  python combine_repetitions_wordbank.py $clean_file

  rm "aoa_wordbank_${lang}_produces_prop0.5_${category}_clean.csv"

}

#Run
main "ita" "Italian" "adjectives"
main "ita" "Italian" "nouns"
main "eng" "English" "adjectives"
main "eng" "English" "nouns"
