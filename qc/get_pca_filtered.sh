#!/bin/bash

plink2 \
    --vcf bipcore-phased.vcf.gz \
    --keep pca.ids \
    --double-id \
    --aec \
    --recode vcf-fid bgz \
    --ref-from-fa PlasmoDB-45_PreichenowiCDC_Genome.fasta \
    --out pca-filtered-phased

