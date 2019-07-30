#!/bin/bash

data="$1"
proga='./helpmsg.sh 1'
progb='./helpmsg.sh 2'
progc='./helpmsg.sh 3'
progd='./helpmsg.sh 4'
proge='./helpmsg.sh 5'
progf='./helpmsg.sh 6'
progg='./helpmsg.sh 7'
progh='./helpmsg.sh 8'
progi='./helpmsg.sh -h'

if [[ $data == "sub" ]]; then

    param="$2"
    
           if [[ "$param" != [123] ]]; then
       
                $proga
       
           else

                if [[ "$param" == "1" && $# != 8 ]]; then
                       
             	     $progb
                   
                elif [[ "$param" == "1" && $# == 8 ]]; then
                 
                       # chromosome region
                       plink2 \
                       	--chr $3 \
                       	--export hapslegend \
                       	--vcf $8 \
                       	--out chr${3}${6}${7} \
                       	--from-kb $4 \
                       	--to-kb $5 \
                       	--keep $6.txt \
                       	--double-id
                       
                       sed '1d' chr${3}${6}${7}.legend | \
			       awk '{print $1"\t""11""\t"$2"\t"$4"\t"$3}' > chr${3}${6}${7}.map
                       sed 's/0/2/g' chr${3}${6}${7}.haps > chr${3}${6}${7}.hap
                    
                elif [[ "$param" == "2" && $# != 5 ]]; then
             
             	       $progc
                   
                elif [[ "$param" == "2" && $# == 5 ]]; then
                 
                       # Entire chromosome
                       plink2 \
                         --chr $3 \
                         --export hapslegend \
                         --vcf $5 \
                         --out chr$3$4 \
                         --keep $4.txt \
                         --double-id
                      
                       sed '1d' chr${3}${4}.legend | \
			       awk '{print $1"\t""11""\t"$2"\t"$4"\t"$3}' > chr${3}${4}.map
                       sed 's/0/2/g' chr${3}${4}.haps > chr${3}${4}.hap
                       
                elif [[ "$param" == "3" && $# != 6 ]]; then
             
             	       $progd   
             
                elif [[ "$param" == "3" && $# == 6 ]]; then
             
                       for chr in `(seq 1 $4)`; do
                        
                	      # Entire dataset with more than one chromosomes             
                                plink2 \
                                  --export hapslegend \
                                  --vcf $6 \
                                  --chr $chr \
                                  --keep $5 \
                                  --out $3${chr} \
                                  --double-id
                  
                                # Set awk variables
                                a='$1"\\t"'
                                b="\"$chr\""
                                c='"\\t"$2"\\t"$4"\\t"$3'
                  
                  	      echo "{print `awk -v vara="$a" -v varb="$b" -v varc="$c" 'BEGIN{print vara varb varc}'`}" > awkProgFile.txt
                  
                                sed '1d' ${3}${chr}.legend | \
                                        awk -f awkProgFile.txt > ${3}${chr}.map
                                sed 's/0/2/g' ${3}${chr}.haps > ${3}${chr}.hap
                       done
             
             	       for chr in `(seq 1 $4)`; do
             
               	           if [[ -f "${3}${chr}.map" ]]; then
               	     
               		       awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5}' ${3}${chr}.map; 
               	   
               		   fi
                 
             	       done > snp.info
             	   
                fi 
       
                for file in *.log *.sample *.legend *.haps awkProgFile.txt; do
                    if [[ -f ${file} ]]; then
                       rm ${file}
                    fi
                done
       
             
           fi

elif [[ $data == "all" ]]; then

    param="$2"

           if [[ "$param" != [123] ]]; then
          
                $proge
       
           else
                if [[ "$param" == "1" && $# != 8 ]]; then
                   
         	  $progf
         	       
                elif [[ "$param" == "1" && $# == 8 ]]; then
         
                        # chromosome region
                        plink2 \
                              --chr $3 \
                              --export hapslegend \
                              --vcf $8 \
                              --out chr${3}${6}${7} \
                              --from-kb $4 \
                              --to-kb $5 \
                              --double-id
               
                        sed '1d' chr${3}${6}${7}.legend | awk '{print $1"\t""11""\t"$2"\t"$4"\t"$3}' > chr${3}${6}${7}.map
                        sed 's/0/2/g' chr${3}${6}${7}.haps > chr${3}${6}${7}.hap
          
                elif [[ "$param" == "2" && $# != 5 ]]; then
         
            	       $progg
         
          
                elif [[ "$param" == "2" && $# == 5 ]]; then
         
                        # Entire chromosome
                        plink2 \
                          --chr $3 \
                          --export hapslegend \
                          --vcf $5 \
                          --out chr$3$4 \
                          --double-id
               
                        sed '1d' chr${3}${4}.legend | awk '{print $1"\t""11""\t"$2"\t"$4"\t"$3}' > chr${3}${4}.map
                        sed 's/0/2/g' chr${3}${4}.haps > chr${3}${4}.hap
          
          
                elif [[ "$param" == "3" && $# != 5 ]]; then
         
         	    $progh     
         
                elif [[ "$param" == "3" && $# == 5 ]]; then
         
                   for chr in `(seq 1 $4)`; do
               	
			 # Entire dataset with more than one chromosomes
                         plink2 \
                           --export hapslegend \
                           --vcf $5 \
               	           --chr $chr \
                           --out $3${chr} \
                           --double-id
               
                 	 # Set awk variables
                 	 a='$1"\\t"'
                 	 b="\"$chr\""	  
                 	 c='"\\t"$2"\\t"$4"\\t"$3'
                 
                 	 echo "{print `awk -v vara="$a" -v varb="$b" -v varc="$c" 'BEGIN{print vara varb varc}'`}" > awkProgFile.txt
               
                         sed '1d' ${3}${chr}.legend | \
				 awk -f awkProgFile.txt > ${3}${chr}.map
                         sed 's/0/2/g' ${3}${chr}.haps > ${3}${chr}.hap
               
                   done
         
                fi
         
                for file in *.log *.sample *.legend *.haps awkProgFile.txt; do
                    if [[ -f ${file} ]]; then
                       rm ${file}
                    fi
                done
         
                   for chr in `(seq 1 $4)`; do
         
                       if [[ -f "${3}${chr}.map" ]]; then
         
                        awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5}' ${3}${chr}.map
         
         	      fi
       	   
                 done > snp.info
       
           fi

else

	$progi | less
fi
