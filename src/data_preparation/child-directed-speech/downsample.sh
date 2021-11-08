# Downsample English corpus
nmbr_ita=`cat ../data/child-directed-speech/ita_0_60_cds_utterances_cleaned_complete.txt | wc -l`
echo "Sampling ${nmbr_ita} lines..."
cat ../data/eng_0_60_cds_utterances_cleaned_complete.txt | sed  '/^$/d'| shuf -n ${nmbr_ita} > ../data/eng_0_60_cds_utterances_cleaned.txt