#!/usr/bin/env bash

home="$HOME/Git/popgen/"
qc="$home/qc/"

conda activate R

awk '{print $1}' ${qc}pca.ids > pca.ids
bcftools view \
   -S pca.ids \
   -Oz \
   -o invcf.vcf.gz ../raw/pass_core_bi_Pf3D7_all_v3.vcf.gz \
   -Oz \
   --threads 15 \
   -o passbicore.vcf.gz

./moi.R passbicore.vcf.gz 20
