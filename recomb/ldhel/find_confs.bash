#!/bin/bash

mkdir -p output
cat monoclonal.ldhel.input.list | parallel echo 'find_confs --num_threads 10 -w 50 -o output/{/}.conf {}.ldhelmet.snps' | xargs -P2 -n8 ldhelmet

