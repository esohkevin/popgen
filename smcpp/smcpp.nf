#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// include {
//   plot as plotMulti
// } from "${projectDir}/smcpp.nf"

workflow {
   println "\nSMCPP WORKFLOW\n"
   //usage()

   getvcf()
      .map {vcfbase, vcf -> tuple(vcfbase, vcf)}
      .set { vcf }
   getsamplefiles()
      .map { samplefile -> tuple(samplefile.simpleName, samplefile) }
      .combine(vcf)
      .set { sample_vcf }

   /// YAAAYY NESTED TUPLES WORK!!! ///

   if(params.with_masking == true) {
      getmask()
         .map { chrom, mask -> tuple("${chrom}", mask) }
         .combine(sample_vcf)
         .map { 
            chrom, mask, popname, samplefile, vcfname, vcf -> 
            tuple(
               chrom, popname, samplefile, vcfname, \
               tuple(vcf, mask)
            )
         }.view()
         .set { vcf2smc_in }
   } else {
      getchrom()
         .combine(sample_vcf)
         .set { vcf2smc_in }
   }

   vcf2smc( vcf2smc_in )
      .map { popname, smcout -> tuple("${popname}", smcout) }
      .groupTuple(by:0)
      .set { smc_file }

   estimate( smc_file ).view()
      .set { smc_model }

   plot( smc_model ).view()   
   plotlinear( smc_model ).view()

   smc_model
      .map { popname, smc_model -> smc_model }
      .collect()
      .toList().view()
      .map { models -> tuple("combined", models) }.view()
      .set { smc_models }
   //plotMulti( smc_models )
}

//def getvcf() {
//    channel.fromFilePairs( params.vcf_dir + "*.{vcf.gz,vcf.gz.tbi}" )
//           .map { key, vcf -> tuple(key, vcf.first(), vcf.last()) }
//}

def getchrom() {
    return channel.from(1..22)
           .map { chrom -> "${chrom}" }
}

def getmask() {
   return channel.fromPath( params.mask_dir + "*.bed.gz" )
         .map { 
            mask -> tuple(mask.simpleName.replaceAll(/hs37d5_chr/,""), mask)
         }
}

def getvcf() {
    return channel.fromPath( params.vcf )
           .map { vcf -> tuple(vcf.simpleName, vcf) }
}


def getsamplefiles() {
    return channel.fromPath( params.sample_dir + "*.txt" )
}

process usage {
   tag "Running SMCPP"
   label 'smcpp'
   echo 'true'
   script:
      """
      smc++ \
         vcf2smc -h \
      """
}

process vcf2smc {
   tag "processing chr${chrom}..."
   label 'smcpp'
   label 'smcpp_mem'
   publishDir \
      path: "${params.output_dir}/input/${popName}", \
      mode: 'copy'
   input:
      tuple \
         val(chrom), \
         val(popName), \
         path(sampleFile), \
         val(vcfName), \
         path(vcf)
   output:
      tuple \
         val(popName), \
         path("chr${chrom}.${popName}.smc.txt.gz")
   script:
   if(params.with_masking == true)
      """ 
      smc++ \
         vcf2smc ${params.vcf} \
         --cores ${task.cpus} \
         --mask \$(readlink ${vcf[1]}) \
         chr${chrom}.${popName}.smc.txt.gz \
         ${chrom} \
         ${popName}:\$(awk '{print \$2}' ${sampleFile} | tr '\n' ',' | sed 's/,\$//g')
      """
   else
      """
      smc++ \
         vcf2smc ${params.vcf} \
         --cores ${task.cpus} \
         chr${chrom}.${popName}.smc.txt.gz \
         ${chrom} \
         ${popName}:\$(awk '{print \$2}' ${sampleFile} | tr '\n' ',' | sed 's/,\$//g')
      """
}

process estimate {
   tag "estimating demographic model"
   label 'smcpp'
   label 'smcpp_mem'
   publishDir \
      path: "${params.output_dir}/output/", \
      mode: 'copy'
   input:
      tuple \
         val(popName), \
         path(smc)
   output:
      tuple \
         val(popName), \
         path("${popName}.smc.${params.spline}.final.json")
   script:
      """
      smc++ \
         estimate \
         --cores ${task.cpus} \
         --outdir . \
         --base ${popName}.smc.${params.spline} \
         --spline ${params.spline} \
         ${params.mu_rate} \
         chr*.smc.txt.gz
      """
}

// 33 34000 (about 1000 to 1 million years ago)
//          --timepoints 33 34000 \

process plot {
   tag "plotting estimates"
   label 'smcpp'
   label 'smallMemory'
   publishDir \
      path: "${params.output_dir}/output/", \
      mode: 'copy'
   input:
      tuple \
         val(popName), \
         path(smcModel)
   output:
      tuple \
         val(popName), \
         path("${popName}.smc.${params.spline}.{png,csv}")
   script:
      """
      smc++ \
         plot \
         -g ${params.generation_time} \
         -c \
         "${popName}.smc.${params.spline}.png" \
         ${smcModel}
      """
}

process plotlinear {
   tag "plotting estimates"
   label 'smcpp'
   label 'smallMemory'
   publishDir \
      path: "${params.output_dir}/output/", \
      mode: 'copy'
   input:
      tuple \
         val(popName), \
         path(smcModel)
   output:
      tuple \
         val(popName), \
         path("${popName}.smc.${params.spline}.linear.{png,csv}")
   script:
      """
      smc++ \
         plot \
         -g ${params.generation_time} \
         -c \
         --linear \
         "${popName}.smc.${params.spline}.linear.png" \
         ${smcModel}
      """
}

