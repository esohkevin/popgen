#!/usr/bin/env bash

home="$HOME/Git/popgen/"
qc="${home}qc/"
raw="${home}/raw/"

conda activate R

awk '{print $1}' ${qc}pca.ids > pca.ids
bcftools view \
   -S pca.ids \
   -Oz \
   --threads 60 \
   -o passbicore.vcf.gz \
   ${raw}pass_core_bi_Pf3D7_all_v3.vcf.gz \

./moi.R passbicore.vcf.gz 30
