#!/bin/bash


file="$1"
atype="$2"
    
if [[ -f "${file/.frq/_updated.frq}" ]]; then
   rm ${file/.frq/_updated.frq}
fi

if [[ $atype == "all" ]]; then
   head -1 $file | awk '{print $1, $2, $3, $4, $5, $6,"TYPE"}' > ${file/.frq/_updated.frq}
   sed '1d' $file | awk '{print $1, $2, $3, $4, $5, $6,"all"}' >> ${file/.frq/_updated.frq}
    
elif [[ $atype == "synonymous" ]]; then
   head -1 $file | awk '{print $1, $2, $3, $4, $5, $6,"TYPE"}' > ${file/.frq/_updated.frq}
   sed '1d' $file | awk '{print $1, $2, $3, $4, $5, $6,"synonymous"}' >> ${file/.frq/_updated.frq}

elif [[ $atype == "nonsynonymous" ]]; then
   head -1 $file | awk '{print $1, $2, $3, $4, $5, $6,"TYPE"}' > ${file/.frq/_updated.frq}
   sed '1d' $file | awk '{print $1, $2, $3, $4, $5, $6,"nonsynonymous"}' >> ${file/.frq/_updated.frq}

else
   echo """Usage: ./prepHist.sh <file.frq> <SNP-type> 
    		
    		SNP-type; all/synonymous/nonsynonymous
    """
fi

