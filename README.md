In this Repo
---
- **raw**: Raw data
- **qc**: Scripts for quality control
- **eig**: Eigenanalysis/PCA and further quality control
   * **CONVERTF**: Preparation of input files for eigenanalysis
   * **EIGENSTRAT**: Eigenanalysis/popstruct
   * **POPGEN**: PCA/Fst (Hudson)
- **ibd**: Identity by descent computation
- **ihs**: Selection scan by the integrated haplotype score
- **fst**: Wier-Cockeham (WC)
- **ld**: Linkage disequilibrium (LD) analysis
- **hflk**: Selection scan by the extended Lewontin-Krakauer Fst outlier test (FLK) and its haplotype variant hapFLK
- **sample**: Sample files
- **maf**: Minor allele frequency analysis
- **lroh**: Long runs of homozygosity
- **recomb**: Fine-scale recombination map computation
- **fws**: Complexity/Multiplicity of infection (for Plasmodium parasite analysis)
------------------------------
Many of the packages used to perform various analyses are not available for 
either the default python installation (2 or 3) or R version. Therefore, 
several anaconda environments were created to handle package incompatibility 
issues. Below are `yml` files for the environments used to handle all packges 
necessary to perform all analyses in this repo.

- R.yml
- R2.yml
- R3.yml
- eigen.yml
- py2.yml
- py3.yml

Create identical env from the `yml` files
```
conda env create -f [].yml 
```

General Usage
---

Pre-processing of raw data (/raw)
-----
Merge single chromosomes into one file
```
./mergeVCFs.sh <file> <output>
``` 

Update chromosome and snp IDs so that plink does not spill out errors
```
./updateIDs.sh <merged-vcf>
```

Extract data for analysis as outlined above (For parasite analysis)
```
./extract_data.sh <updated-vcf>
```

Quality Control (/qc)
-----
Run qc pipeline
```
./qc-pipeline
```

PCA (/eig)
-----
/CONVERTF
```
./convertf_all.sh
```

/EIGENSTRAT
```
./run_eigenstrat.perl
```

/POPGEN
```
./run_popgenstats.sh
```

iHS (/ihs)
-----
Convert phased haplotypes in VCF to rehh format (.hap+.map)
```
./phased_vcf2rehh.sh -h 
```

Get help for using the script by typing '-h' on the commandline

Run scan for selection
```
./runScan.sh
```

Just hit 'enter' and the script will guide you through

Resources
---
- https://github.com/popgenmethods/smcpp
- https://github.com/lh3/psmc
- https://www.palamaralab.org/software/ASMC#tools
- https://github.com/statgen/locuszoom
- https://paldhous.github.io/ucb/2015/dataviz/week7.html
- https://figshare.com/articles/Code_and_metadata_Genetic_architecture_and_selective_sweeps_after_polygenic_adaptation_to_distant_trait_optima/6179219
- https://github.com/Genotek/ClassifyCNV
- https://github.com/VCCRI/VPOT/
- https://github.com/KHP-Informatics/DNAscan
