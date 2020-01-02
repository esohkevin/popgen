#!/bin/bash

################################################################
### QC Pipeline for Cameroonian P.falciparum Pop Struct Analysis
### Tobias Apinjoh & Kevin Esoh (2019)
###

if [[ $# == 5 ]]; then

    #-------Set variables
    in_vcf="$1"
    bname="$(basename $in_vcf)"
    out_vcf="${bname/.vcf.gz/_qc}"
    Lhet="$2"
    Uhet=$3
    maf="$4"
    geno="$5"
    
    #-------- Compute missing data stats
    plink1.9 \
    	--vcf ${in_vcf} \
    	--missing \
	--aec \
    	--allow-no-sex \
    	--out temp1
    
    #-------- Compute heterozygosity stats
    plink1.9 \
    	--vcf ${in_vcf} \
    	--het \
	--aec \
    	--allow-no-sex \
    	--out temp1
    
    echo -e """\e[38;5;40m
    	##########################################################################
    	##	    Perform per individual missing rate QC in R			##
    	##########################################################################
    	\e[0m
    	"""
    echo -e "\n\e[38;5;40mNow generating plots for per individual missingness in R. Please wait...\e[0m\n"
    
    Rscript indmissing.R $Lhet $Uhet ${bname/.vcf*/}
    
    #------- Merge IDs of all individuals that failed per individual qc
    cat ${bname/.vcf*/}_fail-het.qc ${bname/.vcf*/}_fail-mis.qc | sort | uniq > ${bname/.vcf*/}_fail-ind.qc
    
    #-------- Remove individuals who failed per individual QC
    plink1.9 \
    	--vcf ${in_vcf} \
    	--make-bed \
	--aec \
    	--allow-no-sex \
    	--remove ${bname/.vcf*/}_fail-ind.qc \
    	--out temp2
    
    #-------- Per SNP QC
    #-------- Compute missing data rate for ind-qc-camgwas data
    plink1.9 \
    	--bfile temp2 \
    	--allow-no-sex \
    	--missing \
	--aec \
    	--out temp2
    
    # Compute MAF
    plink1.9 \
    	--bfile temp2 \
    	--allow-no-sex \
    	--freq \
	--aec \
    	--out temp2
    
    echo -e """\e[38;5;40m
    	#########################################################################
    	#                        Perform per SNP QC in R                        #
    	#########################################################################
    	\e[0m
    	"""
    echo -e "\n\e[38;5;40mNow generating plots for per SNP QC in R. Please wait...\e[0m\n"
    
    Rscript snpmissing.R ${bname/.vcf*/}
    
    #-------- Remove SNPs that failed per marker QC
    plink1.9 \
    	--bfile temp2 \
    	--allow-no-sex \
    	--maf $maf \
	--aec \
    	--geno ${geno} \
    	--make-bed \
    	--out temp3

    plink2 \
	--bfile temp3 \
	--aec \
	--real-ref-alleles \
	--fa PlasmoDB-45_PreichenowiCDC_Genome.fasta \
	--export vcf-4.2 id-paste=fid bgz \
	--out ${out_vcf}

    rm temp*
else
    echo """
	Usage:./qc-pipeline.sh <in-vcf> <Lhet> <Uhet> <maf-thresh> <geno-thresh>
	Lhet: Lower heterozygosity threshold below which samples are removed for outlying het
	Uhet: Upper heterozygosity threshold

	NB: Lhet and Uhet should be informed by running the qc-pipeline with and an initial
	    Lhet = 0 and Uhet = 1, then observe the resulting *_mishet.png file to set the 
	    right Lhet/Uhet thresholds
    """
fi
