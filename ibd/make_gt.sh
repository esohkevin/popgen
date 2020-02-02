#!/bin/bash

#--Make Genotype file (Derived allele haplotype)
for i in  monoclonal; do #SB BA FO
  bcftools query \
     -H \
     -S ${i}.ids \
     -f '%CHROM\t%POS\t[ %GT]\n' ../qc/passbicore_phased_pca-filtered.vcf.gz | \
     sed 's/.|//g' | \
     sed 's/ /\t/g' | \
     sed 's/#\t//g' | \
     sed 's/:GT//g' | \
     sed 's/\[[[:alnum:]]*\]//g' | \
     sed 's/\t\t/\t/g' > ${i}.gt

#--Make frequency files
 cut -f1-2 ${i}.gt | sed '1d' > ${i}.sites;
 echo ${i} | parallel vcftools --gzvcf ../qc/passbicore_phased_pca-filtered.vcf.gz --positions {}.sites --freq --keep {}.ids --out {}
 sed '1d' ${i}.frq | \
      cut -f1-2,5-6 | \
      sed 's/:/\t/g' | \
      cut -f1-2,4,6 | \
      sed 's/nan/1/g' > frq.${i}.txt;
      rm ${i}.frq ${i}.sites
done
