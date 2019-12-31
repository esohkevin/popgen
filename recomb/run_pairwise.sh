#!/bin/bash

if [[ $# == 3 ]]; then

    base="$1"
    nl="$2"
    nu="$3"

    seq $nl $nu | parallel echo '-seq ${base}chr{}.ldhat.sites -loc ${base}chr{}.ldhat.locs -prefix ${base}chr{}' | xargs -P5 -n6 pairwise

    #pairwise -seq chr10.ldhat.sites -loc chr10.ldhat.locs -prefix chr10
else
    echo """
	Usage: ./run_pairwise.sh <ip> <nl> <nu>
		
		ip: .locs + .sites input prefix
		nl: Lower chromosome number to start with (e.g. 1)
		nu: Upper chromosome number to end with (e.g. 14)
    """
fi
