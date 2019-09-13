#!/bin/bash

bcftools view -S pca.ids -t ^2:105800,10:68970,12:2163700 -Oz -o moi.vcf.gz ../raw/hqcds_bi_Pf3D7_all_v3_updated.vcf.gz
bcftools index -f --tbi moi.vcf.gz
