#!/usr/bin/Rscript

setwd("~/Git/popgen/fws/")
fn <- "all.vcf"

## LOAD REGEX LIBRARY
library(stringr)
library(data.table)

fm <- fread(fn, header = T, nThread = 6)

args <- commandArgs(TRUE)

fn <- args[1]

## READ IN THE Pf AND Pv MULTIVCFs
pvAllVCF <- read.table(fn, comment.char="#", header=TRUE)
pvAllVCF <- as.data.frame(fm)
head(pvAllVCF)
#pvExVCF <- read.table("exons.vcf", comment.char="#", header=TRUE)
#pvNexVCF <- read.table("nonexons.vcf", comment.char="#", header=TRUE)
## DEFINE A FUNCTION THAT WILL CALCULATE Fws FOR EACH DATASET
fwsCalc <- function(dataset) {
  ## REMOVE FIRST NINE COLUMNS FROM THE MULTIVCFs
  data <- dataset[-c(1:9)]

  ## EXTRACT RELEVANT READ DEPTH DATA, FIRST MATCH
  refCT <- as.data.frame(sapply(data, function(x) str_extract(x, ":[0123456789]+,")))
      # The numbers pre-comma are ref counts
      # Convert to data frame on the fly
  refCT <- sapply(refCT, function(x) str_extract(x, "[0123456789]+"))
      # Clean out the extra chars, leaving only numbers
  refCT <- apply(refCT, c(1,2), as.numeric)
      # Convert to a numeric matrix

  altCT <- as.data.frame(sapply(data, function(x) str_extract(x, ",[0123456789]+:")))
      # The numbers post-comma are alt counts
      # Convert to data frame on the fly
  altCT <- sapply(altCT, function(x) str_extract(x, "[0123456789]+"))
      # Clean out the extra chars, leaving only numbers
  altCT <- apply(altCT, c(1,2), as.numeric)
      # Convert to a numeric matrix

  ## CALCULATE qs, ps, and Hs, THE PROPORTIONS OF EACH ALLELE IN THE POPULATION
  ps <- rowSums(refCT)/(rowSums(refCT)+rowSums(altCT))
  qs <- rowSums(altCT)/(rowSums(refCT)+rowSums(altCT))
  Hs <- mean(2*ps*qs)
      # Calculate Hs for each variant and take the mean of all variants

  ## CALCULATE qw, pw, and Hw, THE PROPORTIONS OF EACH ALLELE IN EACH INDIVIDUAL
  totCT <- refCT + altCT
      # Make a matrix of total counts
  pw <- matrix(totCT, nrow = length(data[,1]), ncol = length(names(data)))
      # Set up pw matrix
  qw <- matrix(totCT, nrow = length(data[,1]), ncol = length(names(data)))
      # Set up qw matrix
  Hw <- matrix(totCT, nrow = length(data[,1]), ncol = length(names(data)))
      # Set up Hw matrix

  for (i in 1:length(names(data))) {
    for (j in 1:length(data[,1])) {

      pw[j,i] <- refCT[j,i]/totCT[j,i] # Calculate pw per individual and per allele
      qw[j,i] <- altCT[j,i]/totCT[j,i] # Calculate qw per individual and per allele
      Hw[j,i] <- 2*pw[j,i]*qw[j,i] # Calculate Hw per individual and per allele

    }
  }

  Hw <- colMeans(Hw)
      # Take the column means of Hw matrix, to get a single Hw score for each sample

  ## CALCULATE Fws
  1 - Hw/Hs

}
## FINALLY, PLOT THE GRAPHS
pv_all_fws <- fwsCalc(pvAllVCF)
pv_all_fws
#pv_ex_fws <- fwsCalc(pvExVCF)
#pv_nex_fws <- fwsCalc(pvNexVCF)
png("fws.png", height = 16, width = 16, units = "cm", res = 100, points = 14)
hist(pv_all_fws, breaks=14, main="", xlab="Fws", ylab="Occurrences", axes=FALSE, xlim=c(0.2,1))
axis(1)
axis(2, las=2)
#hist(pv_ex_fws, breaks=14)
#hist(pv_nex_fws, breaks=14)
dev.off()
