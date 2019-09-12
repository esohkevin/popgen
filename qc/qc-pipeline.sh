#!/bin/bash

################################################################
### QC Pipeline for Cameroonian P.falciparum Pop Struct Analysis
### Tobias Apinjoh & Kevin Esoh (2019)
###

if [[ $# == 4 ]]; then

    #-------Set variables
    in_vcf="$1"
    ld="$2"
    maf="$3"
    geno="$4"
    
    #-------- Check for duplicate variants
    plink1.9 \
    	--vcf ${in_vcf} \
    	--allow-no-sex \
    	--list-duplicate-vars ids-only suppress-first \
    	--out dups
    
    #-------- LD-prune the raw data
    plink1.9 \
        --vcf ${in_vcf} \
        --allow-no-sex \
        --indep-pairwise 50 10 ${ld} \
        --out pruned
    
    #-------- Now extract the pruned SNPs to perform check-sex on
    plink1.9 \
        --vcf ${in_vcf} \
        --allow-no-sex \
        --extract pruned.prune.in \
        --make-bed \
        --out temp1
    
    #-------- Compute missing data stats
    plink1.9 \
    	--bfile temp1 \
    	--missing \
    	--allow-no-sex \
    	--out temp1
    
    #-------- Compute heterozygosity stats
    plink1.9 \
    	--bfile temp1 \
    	--het \
    	--allow-no-sex \
    	--out temp1
    
    echo -e """\e[38;5;40m
    	##########################################################################
    	##	    Perform per individual missing rate QC in R			##
    	##########################################################################
    	\e[0m
    	"""
    echo -e "\n\e[38;5;40mNow generating plots for per individual missingness in R. Please wait...\e[0m"
    
    R CMD BATCH indmissing.R
    
    #-------- Extract a subset of frequent individuals to produce an IBD 
    #-------- report to check duplicate or related individuals baseDird on autosomes
    plink1.9 \
    	--bfile temp1 \
    	--autosome \
    	--maf ${maf} \
    	--geno 0.05 \
    	--hwe 1e-8 \
    	--allow-no-sex \
    	--make-bed \
    	--out frequent
    
    #-------- Prune the list of frequent SNPs to remove those that fall within 
    #-------- 50bp with r^2 > 0.2 using a window size of 5bp
    plink1.9 \
    	--bfile frequent \
    	--allow-no-sex \
    	--indep-pairwise 50 10 ${ld} \
    	--out pruned
    
    #-------- Now generate the IBD report with the set of pruned SNPs 
    #-------- (prunedsnplist.prune.in - IN because they're the ones we're interested in)
    plink1.9 \
    	--bfile frequent \
    	--allow-no-sex \
    	--extract pruned.prune.in \
    	--genome \
    	--out genome
    
    echo -e """\e[38;5;40m
    	#########################################################################
    	#              Perform IBD analysis (relatedness) in R                  #
    	#########################################################################
    	\e[0m
    	"""
    echo -e "\n\e[38;5;40mNow generating plots for IBD analysis in R. Please wait...\e[0m"
    
    R CMD BATCH ibdana.R
    
    #------- Merge IDs of all individuals that failed per individual qc
    cat fail-het.qc  fail-mis.qc duplicate.ids1 | sort | uniq > fail-ind.qc
    
    #-------- Remove individuals who failed per individual QC
    plink1.9 \
    	--bfile temp1 \
    	--make-bed \
    	--allow-no-sex \
    	--remove fail-ind.qc \
    	--out temp2
    
    #-------- Per SNP QC
    #-------- Compute missing data rate for ind-qc-camgwas data
    plink1.9 \
    	--bfile temp2 \
    	--allow-no-sex \
    	--missing \
    	--out temp2
    
    # Compute MAF
    plink1.9 \
    	--bfile temp2 \
    	--allow-no-sex \
    	--freq \
    	--out temp2
    
    echo -e """\e[38;5;40m
    	#########################################################################
    	#                        Perform per SNP QC in R                        #
    	#########################################################################
    	\e[0m
    	"""
    echo -e "\n\e[38;5;40mNow generating plots for per SNP QC in R. Please wait...\e[0m"
    
    R CMD BATCH snpmissing.R
    
    #-------- Remove SNPs that failed per marker QC
    plink1.9 \
    	--bfile temp2 \
    	--allow-no-sex \
    	--maf 0.001 \
    	--geno ${geno} \
    	--make-bed \
    	--out qc-data
    
    rm temp* *prune* dups*
else
    echo """
	Usage:./qc-pipeline.sh <in-vcf> <ld-thresh> <maf-thresh> <geno-thresh>
    """
fi
