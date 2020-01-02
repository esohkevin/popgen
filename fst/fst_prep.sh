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
        --indep-pairwise 50 5 0.1 \
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

    #-------- Get 
    #plink \
	#--bfile fst-ready
	#--out fst-ready
	#--recode 12


    
    #-------- Pull sample IDs based on column number
    awk '{print $1, $1, $17}' ../eig/EIGENSTRAT/merged.pca.evec | sed '1d' | grep -v NA > stat.txt
    awk '{print $1, $1, $15}' ../eig/EIGENSTRAT/merged.pca.evec | sed '1d' | grep -v NA > dsex.txt
    awk '{print $1, $1, $19}' ../eig/EIGENSTRAT/merged.pca.evec | sed '1d' | grep -v NA > alt.txt
    awk '{print $1, $1, $20}' ../eig/EIGENSTRAT/merged.pca.evec | sed '1d' | grep -v NA > age.txt
    awk '{print $1, $1, $21}' ../eig/EIGENSTRAT/merged.pca.evec | sed '1d' | grep -v NA > para.txt

    awk '{print $1":"$4}' ${outname}.bim > temp.txt
    tr "\n" "," < temp.txt | sed 's/,$//' > snps.txt
    snps=$(cat snps.txt)
    echo "bcftools view -t ${snps} -Oz -o temp.vcf.gz ${in_vcf}" > get_hier.sh
    chmod 755 get_hier.sh

    ./get_hier.sh
    zcat temp.vcf.gz | sed 's/SNP.Pf3D7/SNP_Pf3D7/g' | sed 's/v3./v3_/g' > hier.vcf.gz
    rm pruned* *.nosex temp*

else
    echo """
    Usage:./fst_prep.sh <in-vcf(plus path)> <maf> <bfile-outname>
    """
fi
