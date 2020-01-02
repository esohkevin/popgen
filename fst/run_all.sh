#!/bin/bash

#. config.sh
source activate R2

if [[ $# != 1 ]]; then
   echo """
   Usage: ./run_all.sh <in-vcf> [Preferably pca-filtered phased vcf]
   """
else
   invcf=$1
   #----Prepare Fst input files
   ./fst_prep.sh $invcf 0.3 fst-ready
   
   
   #----Run Fst with each partition
   for i in age alt para dsex stat; do 
   	./run_fst.sh fst-ready ${i}.txt ${i}; 
   	rm *.nosex *.log; 
   done
   
   #----Extract top Fst markers (informative markers)
   ./extract_best_fst.sh
fi
