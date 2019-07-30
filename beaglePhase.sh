#!/bin/bash

if [[ $# == 2 ]]; then

   java -jar beagle.12Jul19.0df.jar \
	gt=${1} \
	out=${2} \
	burnin=10 \
	iterations=15

else
   echo """
	Usage: ./beaglePhase.sh <vcf-file> <out-file>
   """

fi
