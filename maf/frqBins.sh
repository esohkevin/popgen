#!/bin/bash

#echo -e "bin\t1\t2\t3\t4\t5\t6\t7\t8\t9\t10" > frqheader.txt

awk '$5>0.40 && $5<=0.45' merged.frq | cut -f7 -d' ' | uniq -c | awk '{print $2}' > rownames.txt

awk '$5<=0.05' merged.frq | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.05.txt

awk '$5>0.05 && $5<=0.10' merged.frq | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.10.txt

awk '$5>0.10 && $5<=0.15' merged.frq | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.15.txt

awk '$5>0.15 && $5<=0.20' merged.frq | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.20.txt

awk '$5>0.20 && $5<=0.25' merged.frq | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.25.txt

awk '$5>0.25 && $5<=0.30' merged.frq | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.30.txt

awk '$5>0.30 && $5<=0.35' merged.frq | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.35.txt

awk '$5>0.35 && $5<=0.40' merged.frq | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.40.txt

awk '$5>0.40 && $5<=0.45' merged.frq | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.45.txt

awk '$5>0.45 && $5<=0.50' merged.frq | cut -f7 -d' ' | uniq -c | awk '{print $1}' > bin0.50.txt

paste rownames.txt bin0.05.txt bin0.10.txt bin0.15.txt bin0.20.txt bin0.25.txt bin0.30.txt bin0.35.txt bin0.40.txt bin0.45.txt bin0.50.txt > freqs.txt

#cat frqheader.txt freqs.txt > frqbins.txt

rm bin0.*.txt rownames.txt

Rscript plotMaf.R
