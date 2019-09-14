#!/bin/bash

if [[ $# == 5 ]]; then
   in_vcf="$1"
   popA="$2"
   popB="$3"
   popC="$4"
   out="$5"

   vcftools \
	--gzvcf ${in_vcf} \
        --weir-fst-pop ${popA} \
        --weir-fst-pop ${popB} \
	--weir-fst-pop ${popC} \
	--out $out
else
   echo """
	Usage:./fst_vcft.sh <in-vcf.gz> <pop1> <pop2> <pop3> <out_name>
   """
fi
