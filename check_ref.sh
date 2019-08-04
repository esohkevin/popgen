#!/bin/bash

plink2 \
   --vcf phased_bipass.vcf.gz \
   --keep-allele-order \
   --ref-from-fa PlasmoDB-44_PreichenowiCDC_Genome.fasta \
   --export vcf-4.2 \
   --out phased_bipass_tref

