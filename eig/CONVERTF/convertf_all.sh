#!/bin/bash

if [[ $1 == "sub" ]]; then

    if [[ $1 == "sub" && $# == 5 ]]; then

	vcf="$2"
	maf="$3"
	outname="$4"
	samfile="$5"
    
        # Prune the qc-dataset for SNPs within 50bp with r^2 < 0.2 using a window of 5 SNPs
        plink \
            --vcf "${vcf}" \
            --indep-pairwise 50 10 0.2 \
            --allow-no-sex \
            --keep ${samfile} \
            --keep-allele-order \
            --autosome \
            --double-id \
            --biallelic-only \
            --out qc-ldPruned
        
        plink \
            --vcf "${vcf}" \
            --extract qc-ldPruned.prune.in \
            --allow-no-sex \
            --autosome \
            --keep ${samfile} \
            --keep-allele-order \
            --make-bed \
            --double-id \
            --out qc-camgwas-ldPruned
        
        plink \
            --vcf qc-camgwas-ldPruned \
            --recode \
	    --maf $maf \
            --keep-allele-order \
            --allow-no-sex \
            --double-id \
            --out ${outname}
        
        rm qc-ldPruned* qc-camgwas-ldPruned*
        
        # Convert files into eigensoft compartible formats
        
        ./make_par_files.sh ${outname}
        
        convertf -p par.PED.PACKEDPED
        convertf -p par.PACKEDPED.PACKEDANCESTRYMAP	
        convertf -p par.PACKEDANCESTRYMAP.ANCESTRYMAP
        convertf -p par.ANCESTRYMAP.EIGENSTRAT
    
    else
    	echo """
    	Usage: ./convertf_all.sh sub <in-vcf> <maf> <outname> <sample-file>
    
    	"""
    fi


elif [[ $1 == "all" ]]; then

    if [[ $1 == "all" && $# == 4 ]]; then
	
        vcf="$2"
        maf="$3"
        outname="$4"
    
        # Prune the qc-dataset for SNPs within 50bp with r^2 < 0.2 using a window of 5 SNPs
        plink \
            --vcf "${vcf}" \
            --indep-pairwise 50 10 0.2 \
            --allow-no-sex \
            --autosome \
	    --double-id \
    	    --keep-allele-order \
	    --biallelic-only \
	    --out qc-ldPruned
        
        plink \
            --vcf "${vcf}" \
            --extract qc-ldPruned.prune.in \
            --allow-no-sex \
            --autosome \
	    --keep-allele-order \
            --make-bed \
	    --double-id \
            --out qc-camgwas-ldPruned
        
        plink \
       	    --bfile qc-camgwas-ldPruned \
       	    --recode \
	    --maf $maf \
       	    --keep-allele-order \
       	    --allow-no-sex \
       	    --double-id \
       	    --out ${outname}
        
        rm qc-ldPruned* qc-camgwas-ldPruned*
        
        # Convert files into eigensoft compartible formats
        
        ./make_par_files.sh ${outname}
        
        convertf -p par.PED.PACKEDPED
        convertf -p par.PACKEDPED.PACKEDANCESTRYMAP	
        convertf -p par.PACKEDANCESTRYMAP.ANCESTRYMAP
        convertf -p par.ANCESTRYMAP.EIGENSTRAT
    
    else
    	echo """
    	Usage: ./convertf_all.sh all <in-vcf> <maf> <outname>
    
    	"""
    
    fi

else
	echo """
	Usage: ./convertf_all.sh <[sub|all]>
	
	Please enter 'sub' for subset of samples or 'all' for all samples

	"""
fi

