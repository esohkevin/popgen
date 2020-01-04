#!/bin/bash

if [[ $# != 6 ]]; then
   echo """
	Usage: bash -i run_hflk.sh <flk-data-prfx> <hflk-data-prfx> <from-chr> <to-chr> <ncpu> <K>

	x-data-prfx must be plink binary format (x.bim + x.bed + x.fam)
	K: Number of baplotype clusters to use (e.g. 15)
	NB: Please specify data path. Results will be saved in 'flkout'
   """
else
   conda activate py2
   mkdir -p flkout
   flk=$1; hflk=$2; lc=$3; uc=$4; oflk=$(basename $flk); ohflk=$(basename $hflk) ncpu=$5; k=$6

   #--outgroup=Cambodia
   hapflk --bfile $flk -p flkout/$oflk
   flkman.R flkout/${oflk}_tree.txt flkout/$oflk.flk
   
   seq $lc $uc | parallel echo "--bfile ${hflk}{}flk -K $k --nfit\=2 --ncpu\=$ncpu --kinship flkout/${oflk}_fij.txt --kfrq -p flkout/${ohflk}{}flk" | xargs -P5 -n11 hapflk
   
   seq $lc $uc | parallel echo "hapflk-clusterplot.R flkout/${ohflk}{}flk.kfrq.fit_1.bz2" | xargs -P5 -n2 Rscript
   
   seq $lc $uc | parallel echo "scaling_chi2_hapflk.py flkout/${ohflk}{}flk.hapflk 15 3" | xargs -P5 -n4 python
   # conda search statsmodels # You need this to run scaling_chi2...py

fi

