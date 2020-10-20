#!/bin/bash

if [[ $# != 5 ]]; then
   echo """
	Usage: ./getbim.sh <in-vcf> <ld-thresh> <from-chr> <to-chr> <sample-file>
   """
else
   dname=$(basename $0)
   mkdir -p data
   invcf=$1; ld=$2; lc=$3; uc=$4; s=$5; bname=$(basename $s) out=${bname/.*/}
   plink --vcf $invcf --aec --keep-allele-order --indep-pairwise 50 10 $ld --out temp
   plink --vcf $invcf --make-bed --aec --keep-allele-order --maf 0.2 --keep $s --extract temp.prune.in --out data/$out

   seq $lc $uc | parallel echo "--vcf $invcf --make-bed --aec --chr {} --keep-allele-order --keep $s --maf 0.05 --out data/${out}_chr{}" | xargs -P5 -n13 plink

   ${dname}/prep.R $s data/$out
   mv data/$out.bim data/${out}flk.bim
   mv data/$out.bed data/${out}flk.bed
   
   seq $lc $uc | parallel echo "$s data/${out}_chr{}" | xargs -P5 -n2 ${dname}/prep.R
   seq $lc $uc | parallel echo "data/${out}_chr{}.bed data/${out}_chr{}flk.bed" | xargs -P5 -n2 mv
   seq $lc $uc | parallel echo "data/${out}_chr{}.bim data/${out}_chr{}flk.bim" | xargs -P5 -n2 mv

   rm temp* data/*.log data/*.nosex data/$out.fam 
   for i in $(seq $lc $uc); do rm data/${out}_chr$i.fam; done
fi
