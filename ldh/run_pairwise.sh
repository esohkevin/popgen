#!/bin/bash

if [[ $# == 2 ]]; then

    base="$2"

    for chr in {1..22}; do 
	echo "-seq ${base}chr${chr}.ldhat.sites -loc ${base}chr${chr}.ldhat.locs -prefix ${base}chr${chr}";
    done > arg_file.txt

cat arg_file.txt | xargs -P11 -n6 pairwise

#pairwise -seq chr10.ldhat.sites -loc chr10.ldhat.locs -prefix chr10
else
    echo """
	Usage: ./run_pairwise.sh <#chr> <.sites+.locs-prefix>
    """
fi
