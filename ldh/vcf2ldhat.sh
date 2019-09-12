#!/bin/bash

if [[ $# == 3 ]]; then

    in_vcf="$1"
    chr=$2
    famfile="$3"
    out="$4"

    for chr in $(seq 1 $chr); do
      vcftools \
	--gzvcf ${in_vcf} \
	--chr ${chr} \
	--phased \
	--ldhat \
	--keep ${famfile} \
	--out ${out}chr${chr}
    done

else
    echo """
	Usage: ./vcf2ldhat.sh <in_vcf> <chr#> <sample-file> <out-prefix>
    """

fi
