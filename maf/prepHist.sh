#!/bin/bash

if [[ $# == 0 ]]; then
   echo """
          Usage: ./prepHist.sh <file.frq> <SNP-type> 
               
              SNP-type; all|syn|nsyn

	      syn: synonymous
	     nsyn: nonsynonymous
    """
else
   file=$1
   atype=$2
   f=$(basename $file)
   fa=$(echo ${f#*.})
   fb=$(echo ${f##*.})
   if [[ -f "${f/.frq/.$atype.frq}" ]]; then
      rm ${f/.frq/.$atype.frq}
   fi
   
   if [[ $atype == "all" ]]; then
      echo "CHROM ID POS REF ALT AF TYPE" > ${f/.frq/.$atype.frq}
      grep -wi -e "synonymous" -e "SYNONYMOUS_CODING" $file | \
         awk '{print $1, $2, $3, $4, $5, $6,"syn"}' >> ${f/.frq/.$atype.frq}
      grep -wi -e "nonsynonymous" -e "NON_SYNONYMOUS_CODING" -e "non_synonymous" $file | \
         awk '{print $1, $2, $3, $4, $5, $6,"nsyn"}' >> ${f/.frq/.$atype.frq}

   elif [[ $atype == "syn" ]]; then
      echo "CHROM ID POS REF ALT AF TYPE" > ${f/.frq/.$atype.frq}
      grep -wi -e "synonymous" -e "SYNONYMOUS_CODING" $file | \
         awk '{print $1, $2, $3, $4, $5, $6,"syn"}' >> ${f/.frq/.$atype.frq}
   
   elif [[ $atype == "nsyn" ]]; then
      echo "CHROM ID POS REF ALT AF TYPE" > ${f/.frq/.$atype.frq}
      grep -wi -e "nonsynonymous" -e "NON_SYNONYMOUS_CODING" -e "non_synonymous" $file | \
         awk '{print $1, $2, $3, $4, $5, $6,"nsyn"}' >> ${f/.frq/.$atype.frq}
   else 
       echo "Please choose a SNP-type: 'all' or 'syn' or 'nsyn'"
   fi
fi

