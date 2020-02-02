#!/bin/bash
out=$(basename http://s3.amazonaws.com/plink2-assets/alpha2/plink2_linux_x86_64.zip)
wget -t10 -c http://s3.amazonaws.com/plink2-assets/alpha2/plink2_linux_x86_64.zip -o ${out}
unzip ${out}

mkdir -p ~/bin		# -p is extremely important to make sure that your 
			# existing home bin is not overwritten
cp plink2 ~/bin/



