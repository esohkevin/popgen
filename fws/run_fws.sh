#!/usr/bin/env bash

home="$HOME/esoh/git/popgen/"
qc="${home}qc/"
raw="${home}/raw/"

#conda activate R

awk '{print $1}' ${qc}pca.ids > pca.ids

bcftools query -f '%CHROM\t%POS\t%POS\n' ${qc}passbicore_phased_pca-filtered.vcf.gz > passbicore_phased_pca-filtered.pos.bed
bgzip passbicore_phased_pca-filtered.pos.bed
tabix -b 2 -e 3 passbicore_phased_pca-filtered.pos.bed.gz

bcftools view \
   -S pca.ids \
   -Oz \
   -R passbicore_phased_pca-filtered.pos.bed.gz \
   --threads 20 \
   -o passbicore.vcf.gz \
   ${raw}pass_core_bi_Pf3D7_all_v3.vcf.gz \

#./moi.R passbicore.vcf.gz 30
