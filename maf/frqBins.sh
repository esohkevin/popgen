#!/bin/bash

if [[ $# == 0 ]]; then
   echo -e "\nUsage: ./frqBins.sh <freq-file(s)>\n"
else
   for file in $@; do
      f=$(basename $file)
      fa=$(echo ${f#*.})
      fb=$(echo ${f##*.})
        awk '$6>0.40 && $6<=0.45' $file | cut -f7 -d' ' | uniq -c | awk '{print $2}' > rownames.txt
        awk '$6<=0.05' $file | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.05.txt
        awk '$6>0.05 && $6<=0.10' $file | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.10.txt
        awk '$6>0.10 && $6<=0.15' $file | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.15.txt
        awk '$6>0.15 && $6<=0.20' $file | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.20.txt
        awk '$6>0.20 && $6<=0.25' $file | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.25.txt
        awk '$6>0.25 && $6<=0.30' $file | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.30.txt
        awk '$6>0.30 && $6<=0.35' $file | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.35.txt
        awk '$6>0.35 && $6<=0.40' $file | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.40.txt
        awk '$6>0.40 && $6<=0.45' $file | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.45.txt
        awk '$6>0.45 && $6<=0.50' $file | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.50.txt
        paste rownames.txt bin0.05.txt bin0.10.txt bin0.15.txt bin0.20.txt bin0.25.txt bin0.30.txt bin0.35.txt bin0.40.txt bin0.45.txt bin0.50.txt > freqs.txt
        rm bin0.*.txt rownames.txt
   done
fi   
#Rscript plotMaf.R
