#!/bin/bash
wget http://s3.amazonaws.com/plink2-assets/plink2_linux_x86_64_20190705.zip
unzip plink2_linux_x86_64_20190705.zip

mkdir -p ~/bin		# -p is extremely important to make sure that your 
			# existing home bin is not overwritten
cp plink2 ~/bin/


