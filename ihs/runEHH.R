#!/usr/bin/Rscript
#setwd("~/popgen/")

library(rehh)

## Load data set
args <- commandArgs(TRUE)

sigpos <- as.vector(read.table(args[3]))
pos <- sigpos[1:nrow(sigpos),] 
#pos

# Bifurcation plot
for (locus in pos) {
  
  chr <- args[1]
  hapFile <- paste(args[2],chr,".hap",sep="")
  mapFile <- paste(args[2],chr,".map",sep="")
  
  
  #Initialize names
  bifurc <- paste(args[2],"bif",locus,".png", sep="")
  ehh_plot <- paste(args[2],"ehh",locus,".png", sep="")
  bifAncestMain <- paste(locus,": Ancestral allele", sep="")
  bifDerivMain <- paste(locus,": Derived allele", sep="")
  
  hap <- data2haplohh(hap_file = hapFile, map_file = mapFile, recode.allele = F, 
                      min_perc_geno.hap=100,min_perc_geno.mrk=100, min_maf = 0.05, 
                      haplotype.in.columns=TRUE, chr.name = chr)
  
  
  
  ## Compute EHH
  png(ehh_plot, height = 640, width = 560, units = "px", type = "cairo")
  ehh <- calc_ehh(hap, mrk = locus, limehh = 0.05, polarized = TRUE)
  plot(ehh)
  dev.off()
  
  
  # Furcation
  hap <- data2haplohh(hap_file = hapFile, map_file = mapFile, recode.allele = F, 
                      min_perc_geno.hap=100,min_perc_geno.mrk=100,
                      haplotype.in.columns=TRUE, chr.name = chr)
  
  
  
  # Calculate furcation
  furc <- calc_furcation(hap, mrk = locus, allele = NULL, limhaplo = 2, 
                         phased = TRUE, polarized = TRUE)
  
  png(bifurc, height = 700, width = 640, res = NA, units = "px", type = "cairo")
  layout(matrix(1:2,2,1))  
  plot(furc)
  plot(ehh)
  dev.off()
  
}


