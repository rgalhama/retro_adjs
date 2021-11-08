1) Extracted and cleaned data from CHILDES 
   

English corpora (CHILDES): all (see scripts in wordrep project)

Italian corpora (CHILDES) excluding: 
Klammer and vanOosten corpora; 
corpus = c("Koroschetz", "MacBates1", "Italian-Roma", "Antelmi",
"D_Odorico", "Calambrone", "Roma")

Since the data for English is much larger, it needs to be downsampled, to keep it comparable to Italian.

  
2) Prepare files with only noun-adj and adj-noun pairs: filter_adj.py
   (and then simply cat all intermediate files and redirect to final file)
   
3) In the case of Italian, there are too many false positives (words tagged as adjectives, which are not really so).
   We manually filtered those. We remove the words in the negative_list_adjs_italian.txt 
