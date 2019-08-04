#!/bin/bash

vcfunp="$1"
vcfp="$2"

# Site quality
vcftools \
    --gzvcf ${vcfunp} \
    --site-quality \
    --out ${vcf/.vcf.gz/}


# Long runs of homozygosity
for chr in {1..14}; do 

    vcftools \
	--gzvcf ${vcfp} \
	--LROH \
	--chr ${chr} \
	--out bipass${chr}
done

# Tajima's D (Nucleotide diversity and selection)
vcftools \
    --gzvcf pass_biseg_core_Pf3D7_all_v3_updated.vcf.gz \
    --TajimaD 50 \
    --maf 0.05 \
    --out bipaseg
