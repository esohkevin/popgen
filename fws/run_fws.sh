#!/usr/bin/env bash

home="$HOME/esoh/git/popgen/"
qc="${home}qc/"
raw="${home}/raw/"

#conda activate R

awk '{print $1}' ${qc}pca.ids > pca.ids

bcftools query -f '%CHROM\t%POS\t%POS\n' ${qc}passbicore_phased_pca-filtered.vcf.gz | awk '{print "chr"$0}' > temp.bed

cat temp.bed | \
            sed 's/chr1/Pf3D7_01_v3/1' | \
            sed 's/chr2/Pf3D7_02_v3/1' | \
            sed 's/chr3/Pf3D7_03_v3/1' | \
            sed 's/chr4/Pf3D7_04_v3/1' | \
            sed 's/chr5/Pf3D7_05_v3/1' | \
            sed 's/chr6/Pf3D7_06_v3/1' | \
            sed 's/chr7/Pf3D7_07_v3/1' | \
            sed 's/chr8/Pf3D7_08_v3/1' | \
            sed 's/chr9/Pf3D7_09_v3/1' | \
            sed 's/chr10/Pf3D7_10_v3/1' | \
            sed 's/chr11/Pf3D7_11_v3/1' | \
            sed 's/chr12/Pf3D7_12_v3/1' | \
            sed 's/chr13/Pf3D7_13_v3/1' | \
            sed 's/chr14/Pf3D7_14_v3/1' > passbicore_phased_pca-filtered.pos.bed


[ ! -f "passbicore_phased_pca-filtered.pos.bed.gz" ] && bgzip passbicore_phased_pca-filtered.pos.bed

tabix -f -b 2 -e 3 passbicore_phased_pca-filtered.pos.bed.gz

bcftools view \
   -S pca.ids \
   -Oz \
   -R passbicore_phased_pca-filtered.pos.bed.gz \
   --threads 20 \
   -o passbicore.vcf.gz \
   ${raw}pass_core_bi_Pf3D7_all_v3.vcf.gz

#./moi.R passbicore.vcf.gz 30
