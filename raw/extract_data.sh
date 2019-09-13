#!/bin/bash

### P. falciparum Community Project
### -------------------------------
### 
### Process Version: 6.0
### Date:  13 December 2016
### 
### This zip file contains variant genotype calls for samples belonging to a
### Partner Study within the P. falciparum Community Project.
### 
### The vcf files were generated from alignments of Illumina short reads against the
### Pf3D7_v3 reference genome, with variants called using GATK HaplotypeCaller.
### Please see the process report included in this zip file for more details.
### 
### 
### File Structure and Format
### -------------------------
### 
### The sample_metadata file contains a table of data about the samples, including
### sample identifiers and some sequence and genotype QC metrics.  The columns of
### the table are specified in the process report.
### 
### The data files ("*.vcf.gz") are bgzipped VCF format files containing all samples
### in the study.  There is one file for each chromosome, plus one for the
### mitochondrion and one for the apicoplast. The files, once unzipped, are tab-
### separated text files, but may be too large to open in Excel.
### 
### The VCF format is described in https://github.com/samtools/hts-specs
### 
### Tools to assist in handling VCF files are freely available from
### http://samtools.github.io/bcftools/
### 
### The file regions-20130225.bed.gz defines the core genome used for analysis.
### 
### 
### Contents of the VCF file
### ------------------------
### 
### The VCF file contains details of 6,051,696 discovered variant genome positions.
### These variants were discovered amongst all 7,182 samples from the release. Only
### a subset of the variants will be segregating within any given sample subset.
### 3,846,585 of these variant positions are SNPs, with the remainder being either
### short insertion/deletions (indels), or a combination of SNPs and indels. It is
### important to note that many of these variants are considered low quality. Only
### the variants for which the FILTER column is set to PASS should be considered of
### reasonable quality. There are 3,114,760 such PASS variants of which 2,177,310
### are SNPs and 937,450 indels.
### 
### The FILTER column is based on two types of information. Firstly certain regions
### of the genome are considered "non-core". This includes sub-telomeric regions,
### centromeres and internal VAR gene regions on chromosomes 4, 6, 7, 8 and 12. All
### variants within non-core regions are considered to be low quality, and hence
### will not have the FILTER column set to PASS. The regions which are core and
### non-core can be found in the file regions-20130225.bed.gz.
### 
### Secondly, variants are filtered out based on a quality score called VQSLOD. All
### variants with a VQSLOD score below 0 are filtered out, i.e. will have a value of
### Low_VQSLOD in the FILTER column, rather than PASS. The VQSLOD score for each
### variant can be found in the INFO field of the VCF file. It is possible to use
### the VQSLOD score to define a more or less stringent set of variants (see next
### section for further details).
### 
### It is also important to note that many variants have more than two alleles. For
### example, amongst the 3,114,760 PASS variants, 1,785,737 are biallelic. The
### remaining 1,329,023 PASS variants have 3 or more alleles. The maximum number of
### alternative alleles represented is 6. Note that some positions can in truth have
### more than 6 alternative alleles, particularly those at the start of short tandem
### repeats. In such cases, some true alternative alleles will be missing.
### 
### In addition to alleles representing SNPs and indels, some variants have an
### alternative allele denoted by the * symbol. This is used to denote a "spanning
### deletion". For samples that have this allele, the base at this position has been
### deleted. Note that this is not the same as a missing call - the * denotes that
### there are reads spanning across this position, but that the reads have this
### position deleted yet map on either side of the deletion. For further details see
### https://software.broadinstitute.org/gatk/guide/article?id=6926
### 
### In addition to the VQSLOD score mentioned above, The INFO field contains many
### other variant-level metrics. The metrics QD, MQ, FS, SOR, DP are all measures
### related to the quality of the variant. The VQSLOD score is derived from these
### five metrics.
### 
### AC contains the number of non-reference alleles amongst the samples in the file.
### Because the file contains diploid genotype calls, homozygous non-reference calls
### will be counted as two non-reference alleles, whereas heterozygous calls will be
### counted as one non-reference allele. Where a variant position has more than one
### one non-reference allele, counts of each different non-reference allele are
### given. AN contains the total number of called alleles, including reference
### alleles. A simple non-reference allele frequency can be calculated as AC/AN.
### AC and AN values are all specfic to the samples in the study the VCF was created
### for. All other values in the INFO column are not study-specific, for example DP
### holds the total depth across all samples from all studies.
### 
### Various functional annotations are held in the the SNPEFF variables of the INFO
### field. Where appropriate, the amino acid change caused by the variant can be
### found in SNPEFF_AMINO_ACID_CHANGE. Note that for multi-allelic variants, only
### one annotation is given, and therefore this should not be relied on for non-
### biallelic variants. SNPEFF_AMINO_ACID_CHANGE also does not take account of
### nearby variants, so if two SNPs are present in the same codon, the
### amino acid change given is likely to be wrong. Similarly, if two coding indels
### are found in the same exon, the SNPEFF annotations are likely to be wrong. This
### situation occurs at the CRT locus (see next section for further details).
### 
### Coding variants are identified using the CDS flag in the INFO field. Whether we
### consider the variant a SNP or an indel can be determined using VARIANT_TYPE in
### the INFO field. Whether the variant is biallelic, bi-allelic plus spanning
### deletions or multi-allelic in the full set of 7,812 samples can be determined
### using MULTIALLELIC in the INFO field.
### 
### Columns 10 and onwards of the VCF contain the information for each sample.
### The first component of this (GT) is always the diploid genotype call as
### determined by GATK. A value of 0/0 indicates a homozygous reference call. A
### value of 1/1 indicates a homozygous alternative allele call. 0/1 indicates a
### heterozygous call. A value of 2 indicates the sample has the second alternative
### allele, i.e. the second value in the ALT column. For example 2/2 would mean the
### sample is homozygous the the second alternative allele, 0/2 would mean the
### sample is heterozygous for the reference and second alternative alleles, and 1/2
### would mean the sample is heterozygous for the first and second alternative
### alleles. A value of ./. indicates a missing genotype call, usually because there
### are no reads mapping at this position in that sample.
### 
### 
### Recommendations regarding sets of variants to use in analyses
### -------------------------------------------------------------
### 
### Variants are filtered using the VQSLOD metric. VQSLOD is log(p/q) where p is the
### probability of being true and q is the probability of being false. Theoretically,
### when VQSLOD > 0, p is greater than q, and therefore the variant is more likely
### true than false. Conversely, when VQSLOD < 0, the variant is theoretically more
### like false than true. This is why we have chosen 0 as the threshold to use to
### declare that variants have passed the filters: all PASS variants are
### theoretically more likely true than false. Of course, for variants where VQSLOD
### is only slightly above 0, there is only a slightly greater probability of being
### true than of being false. Therefore, for example, many of the variants with
### values between 0 and 1 are likely to be false.
### 
### Empirically we have found that SNPs tend to be more accurate than indels, coding
### variants tend to be more accurate than non-coding variants, and bi-allelic
### variants tend to be more accurate than multi-allelic variants. If you require a
### very reliable set of variants for genome-wide analysis, and don't mind if you
### miss some real variants, we recommend using only bi-allelic coding SNPs in the
### core genome with a VQSLOD score > 6. There are 83,195 such stringent SNPs in the
### call set. In work elsewhere we have found that such variants have a very low
### false discovery rate, and a sensitivity of around 50% (i.e. this will identify
### around half of the true bi-allelic coding SNPS). We include a command below to
### create such a set of variants.
### 
### If instead you would like to know of all likely variation within a certain
### region, even if this means including a few false variants, we recommend using
### all PASS variants. Finally, if you want to ensure you miss as little as possible
### of the true variation, at the risk of including large numbers of false positives,
### you could ignore the FILTER column and use all variants in the VCF.
### 
### In general, we recommend caution in analysing indels. For any given sample, the
### majority of differences from the reference genome are likely to be due to indels
### in low-complexity non-coding regions, e.g. in length polymorphisms of short
### tandem repeats (STRs), such as homopolymer runs or AT repeats. In general, it is
### difficult to map short reads reliably in such regions, and this is compounded by
### the fact that these regions tend to have high AT content, and in general we
### typically have much lower coverage in high AT regions. Indels also tend to be
### multi-allelic, making analysis much more challenging than for (typically
### bi-allelic) SNPs.
### 
### Despite what is written above, it may often be important to analyse indels in
### order to determine the true nature of variation at a locus. An example of this
### is analysis of haplotypes of codons 72-76 of the chloroquine resistance
### transporter gene PfCRT. These codons are translated from bases 403,612-403,626
### on chromosome 7 (Pf3D7_07_v3:403612-403626). The vcf contains two indels here,
### an insertion of a T after position 403,618, and a deletion of T after position
### 403,622. However, it turns out that every sample that has the insertion after
### 403,618 also has the deletion after 403,622. If we write out the full sequence
### of the 3D7 reference (Ref), and a sample which has both the insertion and
### deletion (Alt), we see the following:
### Ref: TGTGTAAT-GAATAAA = TGTGTAATGAATAAA (amino acid sequence CVMNK)
### Alt: TGTGTAATTGAA-AAA = TGTGTAATTGAAAAA (amino acid sequence CVIEK)
### As can be seen from the above, the single base insertion and deletion are
### equivalent to three SNPs at positions 403,620 (G/T), 403,621 (A/G) and
### 403,623 (T/A). If we had only chosen to analyse SNPs at this locus, we would
### not have seen the CVIEK haplotype.
### 
### 
### Extracting data from the VCF file
### -----------------------------
### 
### We recommend the use of bcftools. To install bcftools, follow the instructions
### at: https://github.com/samtools/bcftools/wiki/HOWTOs
### 
### The following are some commands which you might find useful for extracting data
### from the vcf.gz files.

vcf="$1"

## # To extract sample IDs and put into a file, one per line:
## bcftools query --list-samples ${vcf} > samples.txt
## 
## # To extract chromosome, position, reference allele, all alternate alleles,
## # filter value and VQSLOD for all variants into a tab-delimited file:
# bcftools query -f \
# '%CHROM\t%POS\t%REF\t%ALT{0}\t%ALT{1}\t%ALT{2}\t%ALT{3}\t%ALT{4}\t%ALT{5}\t%FILTER\t%VQSLOD\n' \
# ${vcf} > all_variants.txt
## 
## # To extract chromosome, position, reference allele, all alternate alleles and
## # VQSLOD for PASS SNPs only into a tab-delimited file:
## bcftools query -f \
## '%CHROM\t%POS\t%REF\t%ALT{0}\t%ALT{1}\t%ALT{2}\t%ALT{3}\t%ALT{4}\t%ALT{5}\t%VQSLOD\n' \
## --include 'FILTER="PASS" && TYPE="snp"' \
## ${vcf} > pass_snps.txt
## 
## # To extract chromosome, position, reference allele, alternate allele and VQSLOD
## # for biallelic PASS SNPs only into a tab-delimited file:
## bcftools query -f \
## '%CHROM\t%POS\t%REF\t%ALT{0}\t%VQSLOD\n' \
## --include 'FILTER="PASS" && TYPE="snp" && N_ALT=1' \
## ${vcf} > biallelic_pass_snps.txt
## 
## # To extract chromosome, position, reference allele, alternate allele and VQSLOD
## # for biallelic PASS SNPs that are segregating within the study into a
## # tab-delimited file:
## bcftools query -f \
## '%CHROM\t%POS\t%REF\t%ALT{0}\t%VQSLOD\n' \
## --include 'FILTER="PASS" && TYPE="snp" && N_ALT=1 && AC>0' \
## ${vcf} > biallelic_segregating_pass_snps.txt

# To create a vcf file which contains only PASS bi-allelic coding SNPs with
# VQSLOD > 6 that are segregating:
bcftools view \
--include 'FILTER="PASS" && N_ALT=1 && CDS==1 && TYPE="snp" && VQSLOD>6.0' \
--output-type z \
--output-file pass_bi_cds_${vcf} \
${vcf}
bcftools index --tbi pass_bi_cds_${vcf}

# To create a vcf file which contains only PASS bi-allelic core SNPs with
# VQSLOD > 0 that are segregating:
bcftools view \
--include 'FILTER="PASS" && N_ALT=1 && AC>0 && TYPE="snp" && RegionType="Core" && RegionType!="SubtelomericHypervariable" && VQSLOD>0.0' \
--output-type z \
--output-file pass_bi_core_${vcf} \
${vcf}
bcftools index --tbi pass_bi_core_${vcf}

# To create a vcf file which contains only PASS bi-allelic core SNPs and INDELS with
# VQSLOD > 0:
bcftools view \
--include 'FILTER="PASS" && N_ALT=1 && (TYPE="snp" || TYPE="indel") && RegionType="Core" && RegionType!="SubtelomericHypervariable" && VQSLOD>6.0' \
--output-type z \
--output-file hq_bi_core_${vcf} \
${vcf}
bcftools index --tbi hq_bi_core_${vcf}


# To create a vcf file which contains only PASS bi-allelic coding SNPs with
# VQSLOD > 6 that are segregating:
bcftools view \
--include 'FILTER="PASS" && N_ALT=1 && CDS==1 && TYPE="snp" && VQSLOD>6.0 && AC>0' \
--output-type z \
--output-file pass_biseg_cds_${vcf} \
${vcf}
bcftools index --tbi pass_biseg_cds_${vcf}

# To create a vcf file which contains only PASS bi-allelic core SNPs with
# VQSLOD > 0 that are segregating:
bcftools view \
--include 'FILTER="PASS" && N_ALT=1 && AC>0 && TYPE="snp" && RegionType="Core" && RegionType!="SubtelomericHypervariable" && VQSLOD>0.0 && AC>0' \
--output-type z \
--output-file pass_biseg_core_${vcf} \
${vcf}
bcftools index --tbi pass_biseg_core_${vcf}

# To create a vcf file which contains only PASS bi-allelic core SNPs and INDELS with
# VQSLOD > 0:
bcftools view \
--include 'FILTER="PASS" && N_ALT=1 && (TYPE="snp" || TYPE="indel") && RegionType="Core" && RegionType!="SubtelomericHypervariable" && VQSLOD>6.0 && AC>0' \
--output-type z \
--output-file hq_biseg_core_${vcf} \
${vcf}
bcftools index --tbi hq_biseg_core_${vcf}


## # To extract diploid genotype calls for biallelic PASS SNPs in gene MDR1 into a
## # tab-delimited text file, including the chromosome, position, ref and alt
## # alleles, VQSLOD score and amino acid substituion, and a header containing
## # sample names:
## bcftools query \
## -f '%CHROM\t%POS\t%REF\t%ALT{0}\t%VQSLOD\t%SNPEFF_AMINO_ACID_CHANGE[\t%GT]\n' \
## --regions Pf3D7_05_v3:957890-962149 \
## --include 'FILTER="PASS" && TYPE="snp" && N_ALT=1' \
## --print-header \
## ${vcf} > mdr1_genotypes.txt
## 
## # To extract ref allele depths for biallelic PASS SNPs in gene MDR1 into a
## # tab-delimited text file, including the chromosome, position, ref and alt
## # alleles, VQSLOD score and amino acid substituion, and a header containing
## # sample names:
## bcftools query \
## -f '%CHROM\t%POS\t%REF\t%ALT{0}\t%VQSLOD\t%SNPEFF_AMINO_ACID_CHANGE[\t%AD{0}]\n' \
## --regions Pf3D7_05_v3:957890-962149 \
## --include 'FILTER="PASS" && TYPE="snp" && N_ALT=1' \
## --print-header \
## ${vcf} > mdr1_ref_allele_depth.txt
## 
## # To extract alt allele depths for biallelic PASS SNPs in gene MDR1 into a
## # tab-delimited text file, including the chromosome, position, ref and alt
## # alleles, VQSLOD score and amino acid substituion, and a header containing
## # sample names:
## bcftools query \
## -f '%CHROM\t%POS\t%REF\t%ALT{0}\t%VQSLOD\t%SNPEFF_AMINO_ACID_CHANGE[\t%AD{1}]\n' \
## --regions Pf3D7_05_v3:957890-962149 \
## --include 'FILTER="PASS" && TYPE="snp" && N_ALT=1' \
## --print-header \
## ${vcf} > mdr1_alt_allele_depth.txt


