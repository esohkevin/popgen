## File to calculate LD using VCFtools
## It calculates point estimates for the CP groups
## As well as bootstraps and then calculates LD
## Started 5 November 2015
## Christian Parobek
## Modified by Kevin Esoh for Cameroonian parasites analysis (2019 - 2020)

########################
###### PARAMETERS ######
########################

vcf2use="$1"
#vcf2use=args[1]
s=$2

########################
## CP POINT ESTIMATES ##
########################
if [[ $# != 2 ]]; then
   echo """
   Usage: ldCalc.sh <in-vcf> <sample-file>
   """
else
   for i in {1..14}; do
   ## calculate LD
   vcftools --gzvcf $vcf2use \
   	--hap-r2 \
	--chr $i \
   	--ld-window-bp 100000 \
   	--out chr$i.ld.1-100000
   done
   
   ########################
   ####### BOOTSTRAP ######
   ########################   
   for strap in {1..100}; do # number of bootstraps to do
	if [[ -f "bootstrap/boot/boot$strap.txt" ]]; then
		rm bootstrap/boot/boot$strap.txt
	fi
   	## sample without replacement
   	## sampling with replacement is impossible with vcftools
   	## pull 17 isolates
   	shuf -n17 $s >> bootstrap/boot/boot$strap.txt
   	## subsample the VCF (--recode \)
   	vcftools --gzvcf $vcf2use \
   		--keep bootstrap/boot/boot$strap.txt \
   		--ld-window-bp 100000 \
		--hap-r2 \
		--out bootstrap/ld/boot$strap.ld.1-100000
   echo $strap
   done
fi
