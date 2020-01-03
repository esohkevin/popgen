#!/bin/bash

if [[ $# != 2 ]]; then
   echo """
	Usage: ./getnonmis.sh <variable> <colnum> 
	
	(provide the variable and its column number you wish to extract from merged.pca.evec file)
   """
else
   var=$1
   colnum=$2
   cut -f1,$colnum ../EIGENSTRAT/merged.pca.evec | grep -v 'NA' | awk '{print $1,$1,$2}' | sed '1d' > nonmis${var}.ids
fi
