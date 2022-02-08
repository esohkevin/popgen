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
- karyoploteR: https://bernatgel.github.io/karyoploter_tutorial/
- SMCPP: https://github.com/popgenmethods/smcpp
- PSMC: https://github.com/lh3/psmc
- ASMC: https://www.palamaralab.org/software/ASMC#tools
- LocusZoom: https://github.com/statgen/locuszoom
- DataViz: https://paldhous.github.io/ucb/2015/dataviz/week7.html
- Polygenic adaptation: https://figshare.com/articles/Code_and_metadata_Genetic_architecture_and_selective_sweeps_after_polygenic_adaptation_to_distant_trait_optima/6179219
- ClassifyCNV: https://github.com/Genotek/ClassifyCNV
- VPOT: https://github.com/VCCRI/VPOT/
- DNAscan: https://github.com/KHP-Informatics/DNAscan
- Browning Lab Beagle Utilities: https://faculty.washington.edu/browning/beagle_utilities/utilities.html
- ABC: https://cran.r-project.org/web/packages/abc/index.html
- ARGweaver (ancestral recomb graph): https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4022496/
- Balancing selection: https://github.com/ksiewert/BetaScan
- Calculating selection: https://www.ucl.ac.uk/~ucbhdjm/courses/b242/MaintVar/MaintVar.html
- pyrho (demography-aware ancestral recombination graph): https://github.com/popgenmethods/pyrho
- mutation dating paper: https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.3000586
- mtDNA Evolution: https://academic.oup.com/mbe/article/17/6/951/1037844
- NCBI HAPMAP: https://ftp.ncbi.nlm.nih.gov/hapmap/
- ENSEMBL FTP (GRCh37): http://ftp.ensembl.org/pub/grch37/release-104/gff3/homo_sapiens/
- CODEML: Inference of Episodic Changes in Natural Selection Acting on Protein Coding Sequences via CODEML (https://currentprotocols.onlinelibrary.wiley.com/doi/10.1002/cpbi.2)
- PAML: Detecting the Signatures of Adaptive Evolution in Protein-Coding Genes (https://currentprotocols.onlinelibrary.wiley.com/doi/10.1002/0471142727.mb1901s101)
