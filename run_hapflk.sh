#!/bin/bash

./prep.R pop10.txt merged
mv merged.bim mergedflk.bim
mv merged.bed mergedflk.bed

hapflk --bfile mergedflk -p flkout/merged 	#--outgroup=Cambodia
flkman.R merged_tree.txt merged.flk

for chr in {1..14}; do 
   ./prep.R pop10.txt chr${chr};
   mv chr${chr}.bed chr${chr}flk.bed
   mv chr${chr}.bim chr${chr}flk.bim
done

seq 1 14 | parallel echo '--bfile chr{}flk -K 15 --nfit=2 --ncpu=2 --kinship flkout/merged_fij.txt --kfrq -p flkout/chr{}flk' | xargs -P5 -n11 hapflk

seq 1 14 | parallel echo 'hapflk_clusterplot.R chr7flk.kfrq.fit_1.bz2' | xargs -P5 -n2 Rscript

#seq 1 14 | parallel echo 'scaling_chi2_hapflk.py ... ' | xargs -P5 -n2 Rscript
# conda search statsmodels # You need this to run scaling_chi2...py
