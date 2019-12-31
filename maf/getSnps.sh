#!/bin/bash

if [[ $# == 0 ]]; then
   echo "Usage: ./updatePlafIds.sh [vcf-file(s)]"
else
   for file in $@; do
   f=$(basename $file)
   fa=$(echo ${f#*.})
   fb=$(echo ${f##*.})
       if [[ $fa == "vcf.gz" ]]; then
	  bcftools query -f '%CHROM\t%ID\t%POS\t%REF\t%ALT\t%AF\t%SNPEFF_EFFECT\n' $file > ${f/.vcf.gz/.snps.frq}
       else
          echo """
               Sorry. $file does not appear to be a GZIPPED VCF file!
               Please provide a vcf file in the format file.vcf.gz
          """
       fi
   done
fi     
