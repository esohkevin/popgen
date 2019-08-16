#!/bin/bash

if [[ $# != 3 ]]; then
   echo """
   Usage: ./runEHH.sh <chr#> <rehh-prefix>  <locus-file (end with .txt)>
"""
else

   Rscript runEHH.R $1 $2 $3

   echo "Done running EHH!"

fi
