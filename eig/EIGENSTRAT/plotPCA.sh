#!/bin/bash


if [[ $# == 1 ]]; then

   Rscript eig.R $1

   awk '{print $1,$1}' merged.pca.evec | sed '1d' > ../../qc/pca.ids
   cut -f1,13- merged.pca.evec > ../../fst/pca-pheno.txt
   cp merged.pca.evec ../../sample/
#   mv *.png ../../../images/

#   cut -f4 -d' ' ${1} | sed '1d' > eig.id1
#   cut -f4 -d' ' ${1} | sed '1d' > eig.id2
#   paste eig.id1 eig.id2 > eig.ids
#   rm eig.id1 eig.id2
#   
#   mv ${1}.pca.txt ${1/.pca*/.pcs}

else 
   echo """
	Usage: ./plotPCA.sh <evec-base>
   """

fi
