#!/usr/bin/env bash

source ~/Programas/miniconda3/etc/profile.d/conda.sh
conda activate learningadjs

# 1. Train
# ...

# 2. Test (i.e. use trained model to record predictions and measures over output layer)

#RNN
lang="eng"
#converged epoch (todo: automatize this):
epoch=62
seed=2342
eng_rnn_path_to_data="../../saved_models/model_${lang}_forward_0delay_seed_${seed}_epoch_${epoch}/accuracies_test.csv"
python scripts/test.py --language $lang --seed ${seed} --direction forward --delay 0 \
--path_to_model "$(realpath ../../saved_models/model_${lang}_forward_0delay_seed_${seed}_epoch_${epoch})" \
--input_data "$(realpath ../data/adjective_sentences_cds/${lang}_AN_NA_300.txt)"

lang="ita"
#converged epoch:
epoch=59
seed=2342
ita_rnn_path_to_data="../../saved_models/model_${lang}_forward_0delay_seed_${seed}_epoch_${epoch}/accuracies_test.csv"
python scripts/test.py --language $lang --seed ${seed} --direction forward --delay 0 \
--path_to_model "$(realpath ../../saved_models/model_${lang}_forward_0delay_seed_${seed}_epoch_${epoch})" \
--input_data "$(realpath ../data/adjective_sentences_cds/${lang}_AN_NA.txt)"


#RNN trained backwards

lang="eng"
#converged epoch:
epoch=58
seed=2343
direction="backward"
delay=0
eng_rnn_backward_path_to_data="../../saved_models/model_${lang}_${direction}_${delay}delay_seed_${seed}_epoch_${epoch}/accuracies_test.csv"
python scripts/test.py --language $lang --seed ${seed} --direction ${direction} --delay ${delay} \
--path_to_model "$(realpath ../../saved_models/model_${lang}_${direction}_${delay}delay_seed_${seed}_epoch_${epoch})" \
--input_data "$(realpath ../data/adjective_sentences_cds/${lang}_AN_NA_300.txt)"

lang="ita"
#converged epoch:
epoch=64
seed=2343
direction="backward"
delay=0
ita_rnn_backward_path_to_data="../../saved_models/model_${lang}_${direction}_${delay}delay_seed_${seed}_epoch_${epoch}/accuracies_test.csv"
python scripts/test.py --language $lang --seed ${seed} --direction ${direction} --delay ${delay} \
--path_to_model "$(realpath ../../saved_models/model_${lang}_${direction}_${delay}delay_seed_${seed}_epoch_${epoch})" \
--input_data "$(realpath ../data/adjective_sentences_cds/${lang}_AN_NA.txt)"



## Bidirectional RNN (to do: I need to track the trained models, they are probably in the server)
...

# Delay RNN
lang="eng"
epoch=60
seed=745
eng_delay1_path_to_data="../../saved_models/model_${lang}_forward_1delay_seed_${seed}_epoch_${epoch}/accuracies_test.csv"
python scripts/test.py --language $lang --seed ${seed} --direction forward --delay 1 \
--path_to_model "$(realpath ../../saved_models/model_${lang}_forward_1delay_seed_${seed}_epoch_${epoch})" \
--input_data "$(realpath ../data/adjective_sentences_cds/${lang}_AN_NA_300.txt)"

lang="ita"
epoch=60
seed=744
ita_delay1_path_to_data="../../saved_models/model_${lang}_forward_1delay_seed_${seed}_epoch_${epoch}/accuracies_test.csv"
python scripts/test.py --language $lang --seed ${seed} --direction forward --delay 1 \
--path_to_model "$(realpath ../../saved_models/model_${lang}_forward_1delay_seed_${seed}_epoch_${epoch})" \
--input_data "$(realpath ../data/adjective_sentences_cds/${lang}_AN_NA.txt)"

# 3. Analyze ############################################################################
#use new_entropy_analysis.R script


conda deactivate