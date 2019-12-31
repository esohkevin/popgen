#!/bin/bash

mkdir -p output &&
seq 1 14 | parallel echo 'find_confs --num_threads 10 -w 50 -o output/chr{}.conf ${base}{}.ldhelmet.snps' | xagrs -P2 -n8 ldhelmet

