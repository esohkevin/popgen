#!/bin/bash

if [[ $# != 1 ]]; then
   echo """
   Usage: ./extract_dara.sh <in-vcf>
   """
else
   vcf="$1"
   
   # To extract sample IDs and put into a file, one per line:
   #bcftools query --list-samples ${vcf} > samples.txt
   
   # To create a vcf file which contains only HQ bi-allelic coding SNPs with
   # VQSLOD > 6:
   bcftools view \
   --include 'FILTER="PASS" && N_ALT=1 && CDS==1 && TYPE="snp" && VQSLOD>6.0' \
   --output-type z \
   --threads 10 \
   --output-file hq_cds_${vcf} \
   ${vcf}
   bcftools index --tbi hq_cds_${vcf}
   
   # To create a vcf file which contains only PASS bi-allelic coding SNPs with
   # VQSLOD > 0:
   bcftools view \
   --include 'FILTER="PASS" && N_ALT=1 && CDS==1 && TYPE="snp" && VQSLOD>0.0' \
   --output-type z \
   --threads 10 \
   --output-file pass_cds_${vcf} \
   ${vcf}
   bcftools index --tbi pass_cds_${vcf}
   
   # To create a vcf file which contains only PASS bi-allelic core SNPs with
   # VQSLOD > 0:
   bcftools view \
   --include 'FILTER="PASS" && N_ALT=1 && TYPE="snp" && RegionType="Core" && RegionType!="SubtelomericHypervariable" && VQSLOD>0.0' \
   --threads 10 \
   --output-type z \
   --output-file pass_core_${vcf} \
   ${vcf}
   bcftools index --tbi pass_core_${vcf}
   
   # To create a vcf file which contains only PASS bi-allelic core SNPs and INDELS with
   # VQSLOD > 6:
   bcftools view \
   --include 'FILTER="PASS" && N_ALT=1 && TYPE="snp" && RegionType="Core" && RegionType!="SubtelomericHypervariable" && VQSLOD>6.0' \
   --threads 10 \
   --output-type z \
   --output-file hq_core_${vcf} \
   ${vcf}
   bcftools index --tbi hq_core_${vcf}
   
   # # To create a vcf file which contains only HQ bi-allelic coding SNPs with
   # # VQSLOD > 6 that are segregating:
   # bcftools view \
   # --include 'FILTER="PASS" && N_ALT=1 && CDS==1 && TYPE="snp" && VQSLOD>6.0 && AC>0' \
   # --threads 10 \
   # --output-type z \
   # --output-file pass_biseg_cds_${vcf} \
   # ${vcf}
   # bcftools index --tbi pass_biseg_cds_${vcf}
   
   # To create a vcf file which contains only PASS bi-allelic core SNPs with
   # VQSLOD > 0 that are segregating:
   bcftools view \
   --include 'FILTER="PASS" && N_ALT=1 && AC>0 && TYPE="snp" && RegionType="Core" && RegionType!="SubtelomericHypervariable" && VQSLOD>0.0' \
   --threads 10 \
   --output-type z \
   --output-file pass_seg_core_${vcf} \
   ${vcf}
   bcftools index --tbi pass_seg_core_${vcf}
   
   # # To create a vcf file which contains only PASS bi-allelic core SNPs and INDELS with
   # # VQSLOD > 0:
   # bcftools view \
   # --include 'FILTER="PASS" && N_ALT=1 && (TYPE="snp" || TYPE="indel") && RegionType="Core" && RegionType!="SubtelomericHypervariable" && VQSLOD>6.0 && AC>0' \
   # --threads 10 \
   # --output-type z \
   # --output-file pass_biseg_core_${vcf} \
   # ${vcf}
   # bcftools index --tbi hq_biseg_core_${vcf}
fi
