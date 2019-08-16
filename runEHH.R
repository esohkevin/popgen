#!/usr/bin/Rscript

library(rehh)

## Load data set
args <- commandArgs(TRUE)

chr <- args[1]
hapFile <- paste(args[2],chr,".hap",sep="")
mapFile <- paste(args[2],chr,".map",sep="")
sigpos <- read.table(args[3])

# Bifurcation plot
for (locus in sigpos) {
        
        #Initialize names
        bifurc <- paste(args[2],"bif",locus,".png", sep="")
        bifAncestMain <- paste(locus,": Ancestral allele", sep="")
        bifDerivMain <- paste(locus,": Derived allele", sep="")
        
        hap <- data2haplohh(hap_file = hapFile, map_file = mapFile, recode.allele = F, 
			   min_perc_geno.hap=100,min_perc_geno.mrk=100, min.maf=0.05,
			   haplotype.in.columns=TRUE, chr.name = chr)

       
       
        ## Compute EHH
        png(bifurc, height = 640, width = 560, units = "px", type = "cairo")
        ehh <- calc_ehh(hap, mrk = locus, limehh = 0.05, polarized = TRUE)
        plot(ehh)
        dev.off()

       
        # Furcation
        hap <- data2haplohh(hap_file = hapFile, map_file = mapFile, recode.allele = F, 
                                   min_perc_geno.hap=100,min_perc_geno.mrk=100,
                                   haplotype.in.columns=TRUE, chr.name = chr)
               
               
               
        # Calculate furcation
        png(bifurc, height = 700, width = 640, res = NA, units = "px", type = "cairo")
        layout(matrix(1:2,2,1))
        furc <- calc_furcation(hap, mrk = locus, allele = NULL, limhaplo = 2, 
                               phased = TRUE, polarized = TRUE)
               
        plot(furc)
        dev.off()
               
#       bifurc <- paste(args[2],"bif",locus,".png", sep="")
#       bifAncestMain <- paste(locus,": Ancestral allele", sep="")
#       bifDerivMain <- paste(locus,": Derived allele", sep="")
#       png(bifurc, height = 700, width = 640, res = NA, units = "px", type = "cairo")
#       layout(matrix(1:2,2,1))
#       bifurcation.diagram(hap, mrk_foc = locus, all_foc = 1, nmrk_l = 10, nmrk_r = 10, refsize = 0.05,
#                           main = bifAncestMain)
#       bifurcation.diagram(hap, mrk_foc = locus, all_foc = 2, nmrk_l = 10, nmrk_r = 10, refsize = 0.05,
#                           main=bifDerivMain)
#       dev.off()
}

