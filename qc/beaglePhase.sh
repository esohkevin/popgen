#!/usr/bin/env bash

beaglePhase() {
  if [[ $1 == "nref" && $# != 3 ]]; then
     echo """
        Usage: beaglePhase [wref|nref] [invcf] [outprfx]
     """
  elif [[ $1 == "nref" && $# == 3 ]]; then
       gt=$2; out=$3

          beagle5 \
             gt=${gt} \
             out=${out} \
             burnin=10 \
             iterations=15 \
  
          tabix -f -p vcf ${2}.vcf.gz

  elif [[ $1 == "wref" && $# != 7 ]]; then
     echo """
        Usage: beaglePhase [wref|nref] [invcf] [ref] [map] [burnin] [threads] [outprfx]
     """
  elif [[ $1 == "wref" && $# == 7 ]]; then
       gt=$2; ref=$3; map=$4; bi=$5; mi=$(( $bi*2 )); th=$6; out=$7
       
          beagle5 \
             gt=${gt} \
             ref=${ref} \
             map=${map} \
             burnin=${bi} \
             iterations=${mi} \
             nthreads=${th} \
             out=${out}
  
          tabix -f -p vcf ${2}.vcf.gz
  else
     echo """
        Usage: beaglePhase [wref|nref] (Run beagle5 with or without reference)
     """
  fi
}
