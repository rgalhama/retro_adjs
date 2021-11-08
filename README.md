# Code for Retrodiction as Delayed Recurrence

Ref to paper (ToDo - complete)

Retrodiction as Delayed Recurrence: the Case of Adjectives in Italian and English

## Requirements
This code has only been tested in Linux Mint 19+, with the Python library versions specified in environment.yml, and R version 4.0.4.

## Getting started
The quick recipe:

* Install Miniconda3 (or Conda if preferred):

https://docs.conda.io/en/latest/miniconda.html

* Create an environment using the provided environment.yml file: 

```bash
conda env create -f environment.yml 
```

* You may need to install PyTorch and the Spacy models separately:
```bash
conda install --name learningadjs pytorch==1.5.0 torchvision==0.6.0 -c pytorch

```

Alternatively, use pip from within your activated (virtual) Python environment:
```bash 
cat requirements.txt | xargs -n 1 pip install 
pip install torch==1.5.0+cu101 torchvision==0.6.0+cu101 -f https://download.pytorch.org/whl/torch_stable.html

```


The reported simulations used Spacy v. 2.0.12.
```
conda install -c conda-forge spacy
python -m spacy download en_core_news_sm
python -m spacy download it_core_news_sm
```

The following packages are required for AoA analyses:
```
sudo apt-get -y install r-cran-rmysql libcurl4-gnutls-dev libxml2-dev libssl-dev libmysql++-dev gfortran liblapack-dev liblapack3 libopenblas-base  libopenblas-dev 
```

As well as:
``` 
install.packages("magrittr") 
install.packages("dplyr")    
install.packages('devtools', repos='http://cran.rstudio.com/')
install.packages("stringr") #required for wordbankr
install.packages("wordbankr")
install.packages("optparse")
```

For using R from Bash scripts and command line:
```
sudo apt-get install littler
```

## Reproducing Results

To reproduce the analyses in the paper, :

1. Data Preparation
1. Analyses TPs
1. Analyses AoA
1. Train and test RNNs (see src/scripts)
1. Analyze predictions of RNNs