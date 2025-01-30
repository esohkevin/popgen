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

# Compute relatedness statistic
vcftools \
    --gzvcf pass_bi_core_Pf3D7_all_v3_updated.vcf.gz \
    --relatedness \
    --maf 0.05 \
    --out plaf

# Extract samples with AJK > 0.5 & < 1 where id1 != id2
awk '$3>0.5 && $3<1 && $1!=$2' plaf.relatedness > plaf.related.txt


