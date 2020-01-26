#!/usr/bin/env Rscript

#setwd("~/Git/popgen/fws/")
#args <- c("/home/esoh/Git/popgen/fws/moi.vcf.gz", 10)
args <- commandArgs(TRUE)
if (length(args) < 2) {
  print("", quote = F)
  print("Usage: moi.R [input-vcf] [threads]", quote = F)
  print("",quote = F)
  quit(save = "no")
} else {
  
  invcf <- args[1]
  thr <- args[2]
  
  moi <- function(vcf = input_vcf_file,
                  threads = number_of_additional_threads) {
    
    # Define variables
    outfws <- gsub(".vcf.gz",".fws.txt",vcf)
    outbaf <- gsub(".vcf.gz",".baf.txt",vcf)
    outmult <- gsub(".vcf.gz",".multiclonal.txt",vcf)
    outmplot <- gsub(".vcf.gz",".multiclonal.png",vcf)
    fwsbplot <- gsub(".vcf.gz","_fws_barplot.png",vcf)
    fwsplot <- gsub(".vcf.gz","_fws_plot.png",vcf)
    thr <- threads
    
    # Load required packages. Try installing them if not installed
    if (!require(SeqArray)) {
      print(paste0("Package 'SeqArray' could not be found! Attempting installation..."), quote = F)
      install.packages("SeqArray", repos = 'https://cloud.r-project.org', ask = F, dependencies = T)
      require(SeqArray)
    }
    if (!require(colorspace)) {
      print(paste0("Package 'colorspace' could not be found! Attempting installation..."), quote = F)
      install.packages("colorspace", repos = 'https://cloud.r-project.org', ask = F, dependencies = T)
      require(colorspace)
    }
    if (!require(moimix)) {
      print(paste0("Package 'moimix' could not be found! Attempting installation..."), quote = F)
      if (!require(devtools)) {
	  print(paste0("Attempting installation of 'devtools' required to install 'moimix'..."), quote = F)
          install.packages("devtools", repos = 'https://cloud.r-project.org', ask = F, dependencies = T)
      }
      devtools::install_github("bahlolab/moimix")
      require(moimix)
    }
    if (!require(parallel)) {
      print(paste0("Package 'parallel' could not be found! Attempting installation..."), quote = F)
      install.packages("parallel", repos = 'https://cloud.r-project.org', ask = F, dependencies = T)
      require(parallel)
    }
    if (!require(data.table)) {
      print(paste0("Package 'data.table' could not be found! Attempting installation..."), quote = F)
      install.packages("data.table", repos = 'https://cloud.r-project.org', ask = F, dependencies = T)
      require(data.table)
    }
    
    #----Convert VCF tp GDS
    seqVCF2GDS(vcf, "moi.gds")
    
    #----Open GDS file
    isolates <- seqOpen("moi.gds")
    
    #----Get summary of file
    seqSummary(isolates)  
    
    #----Save sample iDs
    sample.id <- seqGetData(isolates, "sample.id")
    
    #----Get coordinates
    coords <- getCoordinates(isolates)
    
    # Compute B-Allele frequency matrix and save B-allele frequencies to file
    isolate_baf <- bafMatrix(isolates)
    b_allele_frq <- as.data.frame(isolate_baf$coords)
    b_allele_frq$baf <- isolate_baf$baf_site
    bAfrq <- b_allele_frq[,c(1:2,4)]
    fwrite(bAfrq, 
           file = outbaf, 
           sep = " ", 
           row.names = F, 
           col.names = T, 
           nThread = thr, 
           buffMB = 10)
    
    class(isolate_baf)
    str(isolate_baf)
    baf_frame <-  as.data.frame(isolate_baf$baf_matrix)
    tbaf_frame <- t(baf_frame)
    dimnames(isolate_baf$baf_matrix)
    
    # Estimating MOI with fws
    fws_all <- getFws(isolates)
    # Fws abrplot
    png(fwsbplot, 
        height = 16, 
        width = 16, 
        res = 100, 
        units = "cm", 
        points = 14)
    hist(fws_all)
    dev.off()
    
    fws <- as.data.frame(fws_all)
    fws$Sample <- rownames(fws)
    fws <- data.frame(Sample=fws$Sample, fws=fws$fws_all)
    head(fws)
    fwrite(fws, 
           file = outfws, 
           row.names = F, 
           col.names = T, 
           buffMB = 10, 
           sep = " ",
           nThread = thr)
    
    # Fws plot
    png(fwsplot, 
        height = 16, 
        width = 16, 
        res = 100, 
        units = "cm", 
        points = 14)
    plot(fws$fws)
    dev.off()
    
    for (i in sample.id) {
      multclonal <- fws[fws[,c(2)]<0.95, ]
    }
    fwrite(multclonal, 
           file = outmult, 
           row.names = F, 
           col.names = T, 
           buffMB = 10,
           sep = " ", 
           nThread = thr)
    
    # Plot samples with multiclonal infection
    c <- diverge_hcl(3, h = 200, c = 70, l = 40, power = 1.5, alpha = 0.8)
    png(outmplot, 
        height = 15, 
        width = 18, 
        res = 100, 
        units = "cm", 
        points = 14)
    par(mfrow=c(2,3))
    for (i in multclonal$Sample) {
      plot(isolate_baf, i, main = i)
    }
    dev.off()
    
    # Close GDS connection and remove GDS file from hard drive
    seqClose(isolates)
    unlink(c("moi.gds"), force=TRUE)
  }
  
  moi(vcf = invcf, threads = thr)
}
