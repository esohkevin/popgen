#!/bin/bash

for i in age dsex para alt stat; do 
	awk '$5>=0.005 {print $2}' ${i}.fst | \
		sed '1d' > ${i}best_fst.txt; 
done
