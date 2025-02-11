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

   prepVcf(sample_vcf)
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
         }
         .set { vcf2smc_in }
   } else {
      getchrom()
         .combine(sample_vcf)
         .set { vcf2smc_in }
   }

   vcf2smc( vcf2smc_in )
      .set { vcf2smc_out }

   if(params.use_distinguished_pair == true && params.number_dp > 1) {
      vcf2smc_out
         .flatMap { popname, smcouts ->
            smcouts.collect { smcout -> tuple(popname, smcout) }
         }
         .groupTuple(by:0).view()
         .set { smc_file }
   } else {
      vcf2smc_out
         .groupTuple(by:0).view()
         .set { smc_file }
   }

   estimate( smc_file )
      .set { smc_model }

   plot( smc_model ).view()
   plotlinear( smc_model )

   //smc_model
   //   .map { popname, smc_model -> smc_model }
   //   .collect()
   //   .toList().view()
   //   .map { models -> tuple("combined", models) }.view()
   //   .set { smc_models }
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

process prepVcf {
   tag "processing VCF for ${popName}..."
   label 'bcftools'
   label 'bcftools_mem'
   publishDir \
      path: "${params.output_dir}/input/vcf/${popName}"
      //mode: 'copy'
   input:
      tuple \
         val(popName), \
         path(sampleFile), \
         val(vcfName), \
         path(vcf)
   output:
      tuple \
         val(popName), \
         path(sampleFile), \
         val(vcfName), \
         path("${popName}.${vcfName}.smc.vcf.gz")
   script:
      """
      awk '{print \$1}' ${sampleFile} > ${popName}.txt
      bcftools \
         view \
         -v snps \
         -S ${popName}.txt \
         --threads ${task.cpus} \
         ${vcf[0]} | \
      bcftools \
         view \
         -i 'AC>0' \
         --threads ${task.cpus} \
         -Oz | \
      tee ${popName}.${vcfName}.smc.vcf.gz | \
      bcftools \
         index \
         --threads ${task.cpus} \
         -ft \
         -o ${popName}.${vcfName}.smc.vcf.gz.tbi
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
         path("chr${chrom}.${popName}.smc*.txt.gz")
   script:
   if(params.use_distinguished_pair == true)
      if(params.with_masking == true)
         // WITH MASKING AND DISTINGUISHED PAIR
         """
         for i in \$(seq 1 1 ${params.number_dp}); do 
            j=\$(( i++ ))
            smc++ \
               vcf2smc \
               --mask \$(readlink ${vcf[1]}) \
               -d \$(awk '{print \$2}' ${sampleFile} | sed -n "\${j}p;\${j}p" | tr '\\n' ' ' | sed 's/ \$/\\n/g') \
               ${params.vcf} \
               chr${chrom}.${popName}.smc.dp\${j}.txt.gz \
               ${chrom} \
               ${popName}:\$(awk '{print \$2}' ${sampleFile} | tr '\\n' ',' | sed 's/,\$//g')
         done
         """
      else
         // WITHOUT MASKING BUT WITH DISTINGUISHED PAIR
         """
         for i in \$(seq 1 1 ${params.number_dp}); do
            j=\$(( i++ ))
            smc++ \
               vcf2smc \
               -d \$(awk '{print \$2}' ${sampleFile} | sed -n "\${j}p;\${j}p" | tr '\\n' ' ' | sed 's/ \$/\\n/g') \
               -c 12000 \
               ${params.vcf} \
               chr${chrom}.${popName}.smc.dp\${j}.txt.gz \
               ${chrom} \
               ${popName}:\$(awk '{print \$2}' ${sampleFile} | tr '\\n' ',' | sed 's/,\$//g')
         done
         """
   else
      if(params.with_masking == true)
         // WITH MASKING AND NO DISTINGUISHED PAIR
         """
         smc++ \
            vcf2smc \
            --mask \$(readlink ${vcf[1]}) \
            ${params.vcf} \
            chr${chrom}.${popName}.smc.txt.gz \
            ${chrom} \
            ${popName}:\$(awk '{print \$2}' ${sampleFile} | tr '\\n' ',' | sed 's/,\$//g')
         """
      else
         // WITHOUT MASKING AND NO DISTINGUISHED PAIR
         """
         smc++ \
            vcf2smc ${params.vcf} \
            -c 12000 \
            --cores ${task.cpus} \
            chr${chrom}.${popName}.smc.txt.gz \
            ${chrom} \
            ${popName}:\$(awk '{print \$2}' ${sampleFile} | tr '\n' ',' | sed 's/,\$//g')
         """
}

process estimate {
   tag "estimating demographic model for ${popName}"
   label 'smcpp'
   label 'estimateMem'
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
   if(params.set_timepoints == true)
      """
      smc++ \
         estimate \
         --cores ${task.cpus} \
         --timepoints \$(echo \$([[ ${params.tp_from} == 'NULL' ]] && echo 33 || echo ${params.tp_from}) \$([[ ${params.tp_to} == 'NULL' ]] && echo 36000 || echo ${params.tp_to})) \
         \$([[ ${params.aa_known} == true ]] && echo "--unfold") \
         --outdir . \
         --regularization-penalty 6.0 \
         --base ${popName}.smc.${params.spline} \
         --spline ${params.spline} \
         ${params.mu_rate} \
         chr*.smc*.txt.gz
      """
   else
      """
      smc++ \
         estimate \
         --cores ${task.cpus} \
         \$([[ ${params.aa_known} == true ]] && echo "--unfold") \
         --regularization-penalty 6.0 \
         --outdir . \
         --base ${popName}.smc.${params.spline} \
         --spline ${params.spline} \
         ${params.mu_rate} \
         chr*.smc*.txt.gz
      """
}

// 33 34000 (about 1000 to 1 million years ago)
//          --timepoints 33 34000 \

process plot {
   tag "plotting estimates for ${popName}"
   label 'smcpp'
   label 'plotMem'
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
   if(params.set_timepoints == true)
      """
      smc++ \
         plot \
         -g ${params.generation_time} \
         -c \
         -x \$(( ${params.tp_from}*${params.generation_time} )) \$(( ${params.tp_to}*${params.generation_time} )) \
         "${popName}.smc.${params.spline}.png" \
         ${smcModel}
      """
   else
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
   tag "plotting linear estimates for ${popName}"
   label 'smcpp'
   label 'plotMem'
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

