#!/bin/bash


if [[ $# == 2 ]]; then
   
   for file in $(cat $1); do

      tabix -f -p vcf $file

   done

   bcftools concat -f ${1} -a -d all -Oz -o ${2}.vcf.gz

   tabix -f -p vcf ${2}.vcf.gz

#   bcftools view -m2 -M2 -Oz -v snps ${2}.vcf.gz -o ${2}_bi.vcf.gz	# -v: select snps only | -k: select known sites only (not '.')
											# -m -M: max # REF and max # ALT alleles (-m2 -M2 for biallelic only)
											# -p: sites for which all samples are phased
else
   echo """
	Usage: ./plafMerge.sh <file> <output>

	  file: A list containing the VCF file names, one per line
	output: Output file name (only prefix: e.g. Plaf)
   """
fi
