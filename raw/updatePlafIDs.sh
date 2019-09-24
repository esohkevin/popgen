#!/bin/bash

for file in $@; do

    if [[ -f "${file/.vcf.gz/temp.vcf}" ]];then
       rm ${file/.vcf.gz/temp.vcf}
    fi

    bcftools view -h $file > ${file/.vcf.gz/temp.vcf}


    zgrep -v "^#" $file | \
	awk '{print $1"\t"$2"\t"$1":"$2}' > temp_1-3.vcf
    zgrep -v "^#" $file | \
	cut -f 4- > temp_4-end.vcf
    paste temp_1-3.vcf temp_4-end.vcf >> ${file/.vcf.gz/temp.vcf}

    cat ${file/.vcf.gz/temp.vcf} | \
                sed 's/Pf3D7_01_v3/1/g' | \
                sed 's/Pf3D7_02_v3/2/g' | \
                sed 's/Pf3D7_03_v3/3/g' | \
                sed 's/Pf3D7_04_v3/4/g' | \
                sed 's/Pf3D7_05_v3/5/g' | \
                sed 's/Pf3D7_06_v3/6/g' | \
                sed 's/Pf3D7_07_v3/7/g' | \
                sed 's/Pf3D7_08_v3/8/g' | \
                sed 's/Pf3D7_09_v3/9/g' | \
                sed 's/Pf3D7_10_v3/10/g' | \
                sed 's/Pf3D7_11_v3/11/g' | \
                sed 's/Pf3D7_12_v3/12/g' | \
                sed 's/Pf3D7_13_v3/13/g' | \
                sed 's/Pf3D7_14_v3/14/g'  > ${file/.vcf.gz/_updated.vcf}

    bgzip -f ${file/.vcf.gz/_updated.vcf}
    bcftools index -f --tbi ${file/.vcf.gz/_updated.vcf.gz}

    rm *temp*
done
