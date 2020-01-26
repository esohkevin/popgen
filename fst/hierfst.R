#!/usr/bin/env Rscript

#setwd("~/Git/popgen/fst/")

args <- commandArgs(TRUE)

if (length(args) < 1) {
  print("",quote=F)
  print("Usage: hierfst.R [invcf]",quote=F)
  print("",quote=F)
  quit(save="no")
} else {
    invcf <- args[1]
    #------- Load packages
    require(hierfstat)
    require(adegenet)
    require(parallel)
    require(data.table)
    require(pegas)
    
    #------- Read in files
    #ped <- "fst-ready.ped"
    pheno <- "pca-pheno.txt"
    fpheno <- as.data.frame(fread(pheno, nThread = 4))
    #fped <- as.data.frame(fread(ped, nThread = 4))
    
    #------- Make Hierfstat input (from plink ped and a pheno file)
    #pheno_cat <- data.frame(V1=fpheno$Sample, V2=fpheno$DSEX, V3=fpheno$PARACAT, 
    #                        V4=fpheno$Status, V5=fpheno$ALTCAT, V6=fpheno$DAGECAT)
    #
    #fped_trunc <- fped[,-c(2:6)]
    #fhier <- merge(pheno_cat, fped_trunc, by = "V1")
    #
    #fhier$V2 <- as.numeric(ifelse(fhier$V2=="M", 1, 
    #                              ifelse(fhier$V2=="F", 2, "NA")))
    #fhier$V3 <- as.numeric(ifelse(fhier$V3=="High", 1, 
    #                              ifelse(fhier$V3=="Low", 2,
    #                                     ifelse(fhier$V3=="Moderate", 3, "NA"))))
    #fhier$V4 <- as.numeric(ifelse(fhier$V4=="UM", 1, 
    #                              ifelse(fhier$V4=="AP", 2, "NA")))
    #fhier$V5 <- as.numeric(ifelse(fhier$V5=="High", 1, 
    #                              ifelse(fhier$V5=="Low", 2,
    #                                     ifelse(fhier$V5=="Moderate", 3, "NA"))))
    #fhier$V6 <- as.numeric(ifelse(fhier$V6=="Adult", 1, 
    #                              ifelse(fhier$V6=="MidAge", 2,
    #                                     ifelse(fhier$V6=="Under5", 3, "NA"))))
    #
    #
    ##------- Compute WC Fst stats with each pheno
    #dsex_wc <- wc(na.omit(fhier[,-c(1,3:6)]))
    #para_wc <- wc(na.omit(fhier[,-c(1:2,4:6)]))
    #stat_wc <- wc(na.omit(fhier[,-c(1:3,5:6)]))
    #alt_wc <- wc(na.omit(fhier[,-c(1:4,6)]))
    #age_wc <- wc(na.omit(fhier[,-c(1:5)]))
    #
    #dsex_wc
    #para_wc
    #stat_wc
    #alt_wc
    #age_wc
    #
    ##------- Compute basic statistics
    #dsex_bstat <- basic.stats(na.omit(fhier[,-c(1,3:6)]))
    #para_bstat <- basic.stats(na.omit(fhier[,-c(1:2,4:6)]))
    #stat_bstat <- basic.stats(na.omit(fhier[,-c(1:3,5:6)]))
    #alt_bstat <- basic.stats(na.omit(fhier[,-c(1:4,6)]))
    #age_bstat <- basic.stats(na.omit(fhier[,-c(1:5)]))
    #
    #dsex_bstat$overall
    #para_bstat$overall
    #stat_bstat$overall
    #alt_bstat$overall
    #age_bstat$overall
    
    #-------- Load VCF
    fn <- invcf
    x.1 <- VCFloci(fn)
    base <- c("A","T","G","C")
    snps <- which(x.1$REF %in% base & x.1$ALT %in% base)
    x <- read.vcf(fn, which.loci = snps)
    para_dat <- genind2hierfstat(loci2genind(x), pop = fpheno$PARACAT)
    dsex_dat <- genind2hierfstat(loci2genind(x), pop = fpheno$DSEX)
    alt_dat <- genind2hierfstat(loci2genind(x), pop = fpheno$ALTCAT)
    stat_dat <- genind2hierfstat(loci2genind(x), pop = fpheno$Status)
    age_dat <- genind2hierfstat(loci2genind(x), pop = fpheno$DAGECAT)
    
    
    #-------- Compute basic stat
    dsex_bstat <- basic.stats(na.omit(dsex_dat))
    para_bstat <- basic.stats(na.omit(para_dat))
    stat_bstat <- basic.stats(na.omit(stat_dat))
    alt_bstat <- basic.stats(na.omit(alt_dat))
    age_bstat <- basic.stats(na.omit(age_dat))
    print("Parasitemia", quote = FALSE)
    para_bstat$overall
    print("Donor Sex", quote = FALSE)
    dsex_bstat$overall
    print("Donor Status", quote = FALSE)
    stat_bstat$overall
    print("Altitude", quote = FALSE)
    alt_bstat$overall
    print("Donor Age", quote = FALSE)
    age_bstat$overall
    
    #-------- Test Between levels
    #para_tb <- test.between(alt_dat[,-c(1)], test.lev = fpheno$ALTCAT, 
    #                        rand.unit = fpheno$PARACAT)
    
    #-------- Test significance of the effect of level on differentiation
    para_g <- test.g(para_dat[,-c(1)], level = fpheno$PARACAT, nperm = 100)
    alt_g <- test.g(alt_dat[,-c(1)], level = fpheno$ALTCAT, nperm = 100)
    dsex_g <- test.g(dsex_dat[,-c(1)], level = fpheno$DSEX, nperm = 100)
    age_g <- test.g(age_dat[,-c(1)], level = fpheno$DAGECAT, nperm = 100)
    stat_g <- test.g(stat_dat[,-c(1)], level = fpheno$Status, nperm = 100)
    print("Parasitemia", quote = FALSE)
    para_g$p.val
    print("Altitude", quote = FALSE)
    alt_g$p.val
    print("Donor Sex", quote = FALSE)
    dsex_g$p.val
    print("Donor Age", quote = FALSE)
    age_g$p.val
    print("Donor Status", quote = FALSE)
    stat_g$p.val
    
    
    #-------- Plot NJ tree
    png("bionj.png", height = 560, width = 700, units = "px", res = NA, points = 12)
    par(mfrow = c(2,2), mar = c(3,0,3,0))
    for (i in c("alt_dat","para_dat","age_dat")) {
      if (i == "alt_dat") {
        i.name <- "ALTCAT"
        i.main <- "Altitude"
        d <- genet.dist(na.omit(alt_dat))
        d <- as.matrix(d)
        dimnames(d)[[1]] <- dimnames(d)[[2]] <- as.character(levels(alt_dat[,1]))
        my.col <- as.integer(fpheno$i.name)
        x <- table(fpheno$i.name, my.col)
        my.col <- apply(x,1, function(y) which(y>0))
        plot(bionj(d), type = "unrooted", lab4ut = "axial", 
             cex = 0.8, tip.color = my.col, main = i.main)
        mtext(paste0("p-value ",alt_g$p.val), side = 3)
        #text(6, 2, paste0("p-value ", alt_g$p.val),
        #     cex = 0.8)
        
      } else if (i == "para_dat") {
        i.name <- "PARACAT"
        i.main <- "Parasitemia"
        d <- genet.dist(na.omit(para_dat))
        d <- as.matrix(d)
        dimnames(d)[[1]] <- dimnames(d)[[2]] <- as.character(levels(para_dat[,1]))
        my.col <- as.integer(fpheno$i.name)
        x <- table(fpheno$i.name, my.col)
        my.col <- apply(x,1, function(y) which(y>0))
        plot(bionj(d), type = "unrooted", lab4ut = "axial", 
             cex = 0.8, tip.color = my.col, main = i.main)
        mtext(paste0("p-value ",para_g$p.val), side = 3)
        #text(6, 2, paste0("p-value ", para_g$p.val),
        #     cex = 0.8)
        
      } else if (i == "age_dat") {
        i.name <- "DAGECAT"
        i.main <- "Donor Age"
        d <- genet.dist(na.omit(age_dat))
        d <- as.matrix(d)
        dimnames(d)[[1]] <- dimnames(d)[[2]] <- as.character(levels(age_dat[,1]))
        my.col <- as.integer(fpheno$i.name)
        x <- table(fpheno$i.name, my.col)
        my.col <- apply(x,1, function(y) which(y>0))
        plot(bionj(d), type = "unrooted", lab4ut = "axial", 
             cex = 0.8, tip.color = my.col, main = i.main)
        mtext(paste0("p-value ",age_g$p.val), side = 3)
        #text(6, 2, paste0("p-value ", age_g$p.val),
        #     cex = 0.8)
        
      }
    }
    dev.off()
      
    png("boxplots.png", height = 500, width = 700, units = "px", res = NA, points = 13)
    par(mfrow = c(2,3))
    boxplot(age_bstat$perloc[,c(1:3)], main = "Donor Age")
    mtext(paste0("p-value ",age_g$p.val), side = 3)
    boxplot(para_bstat$perloc[,c(1:3)], main = "Parasitemia")
    mtext(paste0("p-value ",para_g$p.val), side = 3)
    boxplot(stat_bstat$perloc[,c(1:3)], main = "Donor Status")
    mtext(paste0("p-value ",stat_g$p.val), side = 3)
    boxplot(alt_bstat$perloc[,c(1:3)], main = "Altitude")
    mtext(paste0("p-value ",alt_g$p.val), side = 3)
    boxplot(dsex_bstat$perloc[,c(1:3)], main = "Donor Sex")
    mtext(paste0("p-value ",dsex_g$p.val), side = 3)
    dev.off()
}
