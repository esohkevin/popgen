#!/bin/bash

for file in $@; do

    if [[ -f "${file/.vcf.gz/_updated.vcf}" ]];then
       rm ${file/.vcf.gz/_updated.vcf}
    fi

    zgrep "^#" $file > ${file/.vcf.gz/_updated.vcf}
    zgrep -v "^#" $file | \
	awk '{print $1"\t"$2"\t"$1":"$2}' > temp_1-3.vcf
    zgrep -v "^#" $file | \
	cut -f 4- > temp_4-end.vcf
    paste temp_1-3.vcf temp_4-end.vcf >> ${file/.vcf.gz/_updated.vcf}
    bgzip -f ${file/.vcf.gz/_updated.vcf}

    rm temp*
done
