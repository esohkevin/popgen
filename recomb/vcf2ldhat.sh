#!/bin/bash

if [[ $# == 4 ]]; then

    in_vcf="$1"
    chr=$2
    thin="$3"
    out="$4"

    for chr in $(seq 1 $chr); do
      vcftools \
	--gzvcf ${in_vcf} \
	--chr ${chr} \
	--phased \
	--ldhat \
	--max-indv $thin \
	--out ${out}chr${chr}
    done

else
    echo """
	Usage: ./vcf2ldhat.sh <in_vcf> <#chr> <thin-samples-to-#> <out-prefix>
    """

fi
