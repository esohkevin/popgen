#!/bin/bash

bcftools view -t ^2:105800,10:68970,12:2163700 -Oz -o new.vcf.gz all.vcf.gz
bcftools index --tbi new.vcf.gz
