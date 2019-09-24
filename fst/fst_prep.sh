#!/bin/bash

if [[ $# == 3 ]]; then
   
    in_vcf="$1"
    maf="$2"
    outname="$3"

    #-------- LD-prune the raw data
    plink1.9 \
        --vcf ${in_vcf} \
        --allow-no-sex \
	--aec \
        --indep-pairwise 50 5 0.5 \
        --out pruned

    #-------- Now extract the pruned SNPs to perform check-sex on
    plink1.9 \
        --vcf ${in_vcf} \
        --allow-no-sex \
	--maf ${maf} \
	--aec \
        --extract pruned.prune.in \
        --make-bed \
        --out ${outname}
    
    #-------- Pull sample IDs based on column number
    awk '{print $1, $1, $17}' ../eig/EIGENSTRAT/merged.pca.evec | sed '1d' | grep -v NA > stat.txt
    awk '{print $1, $1, $15}' ../eig/EIGENSTRAT/merged.pca.evec | sed '1d' | grep -v NA > dsex.txt
    awk '{print $1, $1, $19}' ../eig/EIGENSTRAT/merged.pca.evec | sed '1d' | grep -v NA > alt.txt
    awk '{print $1, $1, $20}' ../eig/EIGENSTRAT/merged.pca.evec | sed '1d' | grep -v NA > age.txt
    awk '{print $1, $1, $21}' ../eig/EIGENSTRAT/merged.pca.evec | sed '1d' | grep -v NA > para.txt

    rm pruned* *.nosex

else
    echo """
    Usage:./fst_prep.sh <in-vcf(plus path)> <maf> <bfile-outname>
    """
fi
