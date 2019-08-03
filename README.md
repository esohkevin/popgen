Population Genetics Tool
---

- Population Structure Analysis
- Selection Scan (iHS, EHH)
- Fst
- LD
- MAF
- Fws

Pipeline
----
- Merge chromosome 1-14 into a single file (Pf3D7\_all\_v3.vcf.gz)
- Extract working samples
  * Biallelic core SNPs that pass all filters (VSQLOD>0)
  * Biallelic CDS
  * Biallelic core SNPs that pass all filters and are segregating within the populations (VSQLOD>0 && AC>0)
  * Biallelic core SNPs with high quality (VSQLOD>0 && AC>0)
  * Biallelic core SNPs with high quality and are segregating within the populations (VSQLOD>6 && AC>0)

- Phase datasets (BEAGLE v5.0)
- Compute recombination map (LDhat)
- 
