#!/bin/bash


if [[ $# == 1 ]]; then
   Rscript eig.R $1

#   mv *.png ../../../images/

#   cut -f4 -d' ' ${1} | sed '1d' > eig.id1
#   cut -f4 -d' ' ${1} | sed '1d' > eig.id2
#   paste eig.id1 eig.id2 > eig.ids
#   rm eig.id1 eig.id2
#   
#   mv ${1}.pca.txt ${1/.pca*/.pcs}

else 
   echo """
	Usage: ./plotPCA.sh <evec-input>
   """

fi
