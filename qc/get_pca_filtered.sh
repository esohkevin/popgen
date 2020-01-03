#!/bin/bash

if [[ $# != 1 ]]; then
   echo """
   Usage: ./get_pcafiltered.sh <in-vcf>
   """
else
   invcf=$1
   bname=$(basename $invcf)
   plink2 \
    --vcf $invcf \
    --keep pca.ids \
    --double-id \
    --aec \
    --export vcf-4.2 id-paste=fid bgz \
    --fa PlasmoDB-45_PreichenowiCDC_Genome.fasta \
    --out ${bname/.vcf*/_pca-filtered}
fi
