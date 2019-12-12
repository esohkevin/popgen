#!/bin/bash

beaglePhase() {
  if [[ $# == 2 ]]; then
      beagle \
  	gt=${1} \
  	out=${2} \
  	burnin=10 \
  	iterations=15 \
  	nthreads=4
  
      bgzip ${2}
      tabix -f -p vcf ${2}.vcf.gz
  
      if [[ $? != 0 ]]; then
          beagle5 \
             gt=${1} \
             out=${2} \
             burnin=10 \
             iterations=15 \
             nthreads=4
  
          bgzip ${2}
          tabix -f -p vcf ${2}.vcf.gz
      fi
  
  else
     echo """
  	Usage: ./beaglePhase.sh <vcf-file> <out-file>
     """
  
  fi
}
