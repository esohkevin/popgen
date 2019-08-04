#!/bin/bash

vcfunp="$1"
vcfp="$2"

vcftools \
    --gzvcf ${vcfunp} \
    --site-quality \
    --out ${vcf/.vcf.gz/}

for chr in {1..14}; do 

    vcftools \
	--gzvcf ${vcfp} \
	--LROH \
	--chr ${chr} \
	--out bipass${chr}
done

