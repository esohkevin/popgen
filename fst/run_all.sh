#!/bin/bash

#----Prepare Fst input files
./fst_prep.sh ../qc/bipcore.vcf.gz 0.3 fst-ready


#----Run Fst with each partition
for i in age alt para dsex stat; do 
	./run_fst.sh fst-ready ${i}.txt ${i}; 
	rm *.nosex *.log; 
done

#----Extract top Fst markers (informative markers)
./extract_best_fst.sh


