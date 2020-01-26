In this Repos
---
- raw: Raw data
- qc: Scripts for quality control
- eig: Eigenanalysis/PCA and further quality control
   * CONVERT: Preparation of input files for eigenanalysis
   * EIGENSTRAT: Eigenanalysis/popstruct
   * POPGEN: PCA/Fst (Hudson)
- ibd: Identity by descent computation
- ihs: Selection scan by the integrated haplotype score
- fst: Wier-Cockeham (WC)
- ld: Linkage disequilibrium (LD) analysis
- hflk: Selection scan by the extended Lewontin-Krakauer Fst outlier test (FLK) and its haplotype variant hapFLK
- sample: Sample files
- maf: Minor allele frequency analysis
- lroh: Long runs of homozygosity
- recomb: Fine-scale recombination map computation
- fws: Complexity/Multiplicity of infection (for Plasmodium parasite analysis)
------------------------------
Many of the packages usd to perform various analyses are not available for 
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
Merge single chromosomes into one file
```
./mergeVCFs.sh <file> <output>
``` 

Update chromosome and snp IDs so that plink does not spill out errors
```
./updatePlafIDs.sh <merged-vcf>
```

Extract data for analysis as outlined above
```
./extract_data.sh <updated-vcf>
```

Phase extracted data with BEAGLE v5.0
```
./beaglePhase.sh <extracted-vcf> <output-prefix>
```

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


