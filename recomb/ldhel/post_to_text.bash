#!/bin/bash

mkdir -p output
#cat monoclonal.ldhel.input.list | parallel echo 'find_confs --num_threads 10 -w 50 -o output/{/}.conf {}.ldhelmet.snps' | xargs -P2 -n8 ldhelmet

#cat monoclonal.ldhel.input.list | parallel echo 'table_gen --num_threads 10 -t 0.008 -r 0.0 0.1 10.0 1.0 100.0 -c output/{/}.conf -o output/{/}.lk' | xargs -P2 -n15 time ldhelmet

#cat monoclonal.ldhel.input.list | parallel echo 'pade --num_threads 10 -t 0.008 -x 12 --defect_threshold 40 -c output/{/}.conf -o output/{/}.pade' | xargs -P2 -n13 time ldhelmet

#cat monoclonal.ldhel.input.list | parallel echo 'rjmcmc --num_threads 24 -l output/{/}.lk -p output/{/}.pade -m mut_mat.txt -s {}.ldhelmet.snps -b 50 --burn_in 100000 -n 1000000 -o output/{/}.post' | xargs -P2 -n19 time ldhelmet

cat monoclonal.ldhel.input.list | parallel echo 'post_to_text -m -p 0.025 -p 0.50 -p 0.975 -o output/{/}.txt output/{/}.post' | xargs -P2 -n11 time ldhelmet
