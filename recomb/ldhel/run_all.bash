#!/bin/bash

# if [[ $# != 1 ]]; then
# 	echo """
# 	Usage: ./run_all.sh [comb|sing]
# 		comb: For combined recomb map
# 		sing: For single chromosomes
# 	"""
mkdir -p output
#cat monoclonal.ldhel.combined.input.list | parallel time ldhelmet find_confs --num_threads 10 -w 50 -o output/output.conf {}{1..14}.ldhelmet.snps

#time ldhelmet table_gen --num_threads 24 -t 0.008 -r 0.0 0.1 10.0 1.0 100.0 -c output/output.conf -o output/output.lk

#time ldhelmet pade --num_threads 10 -t 0.008 -x 12 --defect_threshold 40 -c output/output.conf -o output/output.pade

#cat monoclonal.ldhel.input.list | parallel echo 'rjmcmc --num_threads 24 -l output/output.lk -p output/output.pade -m mut_mat.txt -s {}.ldhelmet.snps -b 50 --burn_in 100000 -n 1000000 -o output/{/}.post' | xargs -P2 -n19 time ldhelmet

#cat monoclonal.ldhel.input.list | parallel echo 'post_to_text -m -p 0.025 -p 0.50 -p 0.975 -o output/{/}.txt output/{/}.post' | xargs -P4 -n11 time ldhelmet

cat monoclonal.ldhel.input.list | parallel echo 'max_lk --num_threads 24 -l output/output.lk -p output/output.pade -m mut_mat.txt -s {}.ldhelmet.snps' | xargs -P2 -n11 time ldhelmet

# bash find_confs.bash
# bash table_gen.bash
# bash pade.bash
# bash rjmcmc.bash
# bash post_to_text.bash
# bash max_lk.bash
