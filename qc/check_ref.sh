#!/bin/bash

if [[ $# == 2 ]]; then

    vcf="$1"
    ref="$2"
    
    plink2 \
       --vcf $vcf \
       --keep-allele-order \
       --ref-from-fa $ref \
       --export vcf-4.2 bgz \
       --out ${vcf/.vcf.gz/_bipass_tref}

else
    echo """
	Usage:./check_ref.sh <in-vcf> <ref-fasta>
    """
fi
