#!/bin/bash

vcf="$1"
ref="$2"

plink2 \
   --vcf $vcf \
   --keep-allele-order \
   --ref-from-fa $ref \
   --export vcf-4.2 bgz \
   --out ${vcf/.vcf.gz/_bipass_tref}

