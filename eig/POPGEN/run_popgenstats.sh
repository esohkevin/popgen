#!/bin/bash

if [[ $# == 2 ]]; then

   base="$1"
   thr="$2"

   #for i in ALTCAT DAGECAT DSEX PARACAT Status; do Rscript prepIndFile.R $i ${i/nonmis/}; done
   Rscript prepIndFile.R $base ${base/nonmis/}
   
   #sed 's/FID/\#FID/g' ../CONVERTF/${base}-eth.txt > ../CONVERTF/${base}-eth.ind
   #sed 's/FID/\#FID/g' ../CONVERTF/${base}-reg.txt > ../CONVERTF/qc-camgwas-reg.ind
   #rm ../CONVERTF/${base}-eth.txt #../CONVERTF/qc-camgwas-reg.txt
   
   echo """
   genotypename:    ../CONVERTF/${base}.eigenstratgeno
   snpname:         ../CONVERTF/${base}.snp
   indivname:       ../CONVERTF/${base}-ald.ind
   #evecoutname:     ${base}.evec
   #evaloutname:     ${base}.eval
   altnormstyle:    NO
   #outlieroutname:  ${base}.outlier
   familynames:     NO
   snpweightoutname:      ${base}-snpwt
   deletesnpoutname:       ${base}-badsnps
   numthreads:      $thr
   fstdetailsname:  ${base/nonmis/}_big.out
   fstz:  YES
   ldregress:       200
   #phylipoutname:   ${base}.phy
   fstonly:         YES
   """ > par.${base/nonmis/}-fst
   
   #sed -i 's/NGS_SNP.//1' ../CONVERTF/${base}.snp 
   echo "smartpca -p par.${base/nonmis/}-fst > fst-eth.txt"
   smartpca -p par.${base/nonmis/}-fst > ${base/nonmis/}.txt

   sed '1d' ${base/nonmis/}_big.out | awk '$6>0.001 {print $3}' | sort | uniq > ${base/nonmis/}_fstsnps.txt
   
   #smartpca -p par.smartpca-ancmap-reg-fst > par.smartpca-ancmap-reg-fst.log
   #smartpca -p par.smartpca-fst > smartpca-fst.log
   #smartpca -p par.smartpca-pca-grm > smartpca-pca-grm.log
   #./../run_twstatsperl

else 
   echo """
	Usage:./run_popgen.sh <ancestrymapgeno-root> <threads>
   """
fi
