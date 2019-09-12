#!/bin/bash

if [[ $# == 3 ]]; then

    in_file="$1"
    samf="$2"
    outname="$3"

    plink \
	--bfile ${in_file} \
	--fst \
	--within ${samf} \
	--out ${outname}

else
    echo """
	Usage./run_fst <in-bfile> <pop-file> <out-name>

	(Specify the paths)
    """
fi
