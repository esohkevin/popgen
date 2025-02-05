#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

workflow {
   println "\nSMCPP WORKFLOW\n"

   autosomes()
     .set { autosome }

   getsamplefiles()
     .set { samplefiles }

   autosome
     .combine( samplefiles )
     .set { chromsamples }

   getvcfforsegsites()
     .combine( chromsamples, by: 0 )
     .set{ segsites }

   getsegregatingsites( segsites )
     .set { vcfs }

   getcleanvcfs( vcfs )
     .view()
     .set { cleanvcfs }
   indexvcf( cleanvcfs )
     .view()
}

def autosomes() {
    channel.of(1..22)
           .map { key -> tuple("${key}") }
}

def getvcfforsegsites() {
    channel.fromFilePairs( params.vcf_path + "*.{vcf.gz,vcf.gz.tbi}" )
           .map { key, vcf -> tuple(vcf.first().simpleName.replaceAll(/chr/,""), vcf.first(), vcf.last()) }
}

def getsamplefiles() {
    channel.fromPath( params.sample_path + "*.txt" )
           .map { sample -> tuple(sample.simpleName, sample) }
}

process getsegregatingsites {
   tag "processing chr${chrom}"
   label 'bcftools'
   label 'bcftools_mem'
   input:
      tuple \
         val(chrom), \
         path(vcf), \
         path(index), \
         val(popname), \
         path(sample)
   output:
      tuple \
        val(chrom), \
        path("chr${chrom}_${popname}.vcf.gz"), \
        val(popname)
   script:
      """
      chrom=\$(zgrep -v "^#" ${vcf} | cut -f1 | head -1)

      bcftools \
        reheader \
        --fai ${params.ref} \
        ${vcf} | \
      bcftools \
        view \
        -S ${sample} \
        -v snps \
        -m2 \
        -M2 \
        -Oz \
        --threads ${task.cpus} \
        -o chr${chrom}.tmp2.vcf.gz \
        ${vcf}

      bcftools \
         norm \
         --threads ${task.cpus} \
         -m+both chr${chrom}.tmp2.vcf.gz | \
      bcftools \
         view \
         -v snps \
         -m2 \
         -M2 \
         --threads ${task.cpus} \
         -Oz \
         -o chr${chrom}_${popname}.vcf.gz

      #bcftools \
      #  reheader \
      #  --fai ${params.ref} \
      #  -o chr${chrom}_${popname}.vcf.gz \
      #  chr${chrom}.${popname}.tmp.vcf.gz
      """
}

//        -r \${chrom} \

process getcleanvcfs {
   tag "processing chr${chrom}"
   label 'plink2'
   label 'plink_mem'
   input:
      tuple \
         val(chrom), \
         path(vcf), \
         val(popname)
   output:
      tuple \
        val(chrom), \
        path("chr${chrom}.${popname}.vcf.gz"), \
        val(popname)
   script:
      """
      plink2 \
        --allow-extra-chr \
        --chr ${chrom} \
        --double-id \
        --geno 0.05 \
        --hwe 1e-6 \
        --maf 0.01 \
        --export vcf-4.2 bgz id-paste='iid' \
        --max-alleles 2 \
        --min-alleles 2 \
        --mind 0.10 \
        --out chr${chrom}.tmp \
        --snps-only just-acgt \
        --vcf ${vcf} \
        --vcf-half-call missing

      plink2 \
        --vcf chr${chrom}.tmp.vcf.gz \
        --export vcf-4.2 bgz id-paste='iid' \
        --out chr${chrom}.${popname}

      #  --ref-allele 'force' ${params.anc_sites} 6 3 "#" \
      #--king-cutoff 0.05 \
      """
}

process indexvcf {
   tag "processing chr${chrom}"
   label 'bcftools'
   label 'bcftools_mem'
   publishDir \
      path: "${params.output_path}/${popname}/", \
      mode: 'copy'
   input:
      tuple \
         val(chrom), \
         path(vcf), \
         val(popname)
   output:
      tuple \
        val(chrom), \
        path(vcf), \
        path("chr${chrom}.${popname}.vcf.gz.tbi"), \
        val(popname)
   script:
      """
      bcftools \
        index \
        -ft \
        --threads ${task.cpus} \
        ${vcf}
      """
}

