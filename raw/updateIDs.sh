#!/bin/bash


if [[ $# == 0 ]]; then
   echo "Usage: ./updatePlafIds.sh [vcf-file(s)]"
else
   for file in $@; do
   f=$(basename $file)
   fa=$(echo ${f#*.})
   fb=$(echo ${f##*.})
       if [[ $fa == *vcf.gz || $fb == *vcf ]]; then
          bcftools view -h $file > ${f/.vcf.gz/_updated.vcf}
          zgrep -v "^#" $file | \
             awk '{print $1"\t"$2"\t""NGS_SNP."$1"."$2}' > temp_1-3.vcf
          zgrep -v "^#" $file | \
             cut -f 4- > temp_4-end.vcf
          paste temp_1-3.vcf temp_4-end.vcf | \
                      sed 's/Pf3D7_01_v3/Pf3D7_01_v3/1' | \
                      sed 's/Pf3D7_02_v3/Pf3D7_02_v3/1' | \
                      sed 's/Pf3D7_03_v3/Pf3D7_03_v3/1' | \
                      sed 's/Pf3D7_04_v3/Pf3D7_04_v3/1' | \
                      sed 's/Pf3D7_05_v3/Pf3D7_05_v3/1' | \
                      sed 's/Pf3D7_06_v3/Pf3D7_06_v3/1' | \
                      sed 's/Pf3D7_07_v3/Pf3D7_07_v3/1' | \
                      sed 's/Pf3D7_08_v3/Pf3D7_08_v3/1' | \
                      sed 's/Pf3D7_09_v3/Pf3D7_09_v3/1' | \
                      sed 's/Pf3D7_10_v3/Pf3D7_10_v3/1' | \
                      sed 's/Pf3D7_11_v3/Pf3D7_11_v3/1' | \
                      sed 's/Pf3D7_12_v3/Pf3D7_12_v3/1' | \
                      sed 's/Pf3D7_13_v3/Pf3D7_13_v3/1' | \
                      sed 's/Pf3D7_14_v3/Pf3D7_14_v3/1' >> ${f/.vcf.gz/_updated.vcf}
          bgzip -f ${file/.vcf.gz/_updated.vcf}
          bcftools index -f --tbi ${file/.vcf.gz/_updated.vcf.gz}
          rm *temp*
       else
          echo "Sorry. $file does not appear to be a valid VCF file!"
       fi
   done
fi
