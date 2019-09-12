#!/bin/bash


if [[ $# == 1 ]]; then
   
   Rscript -e 'source("~/Git/popgen/eig/EIGENSTRAT/eig-fst.R"); evec_plot(evec_root = c("agebest","altbest","statbest","parabest","dsexbest"), pheno_file = "../CONVERTF/pheno.txt", out_name = "pca-fst")'


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
	Usage: ./plotPCA.sh <evec-base>
   """

fi
