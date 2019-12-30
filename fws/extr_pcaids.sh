#!/bin/bash

bcftools view -S pca.ids -t ^Pf3D7_10_v3:68970 -Oz -o moi.vcf.gz ../raw/hq_bi_core_bi_Pf3D7_all_v3.vcf.gz
bcftools index -f --tbi moi.vcf.gz

#-t ^2:105800,10:68970,12:2163700
