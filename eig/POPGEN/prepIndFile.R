#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

if (length(args) < 2) {
   print("Usage: Rscript [prepIndfile.R] [colname] nonmisALTCAT", quote=F)
   print("Please provide a prefix e.g. nonmisALTCAT and the column name of the level in the merged.pca.evec file", quote=F)
   print("",quote=F)
   quit(save="no")
} else {
   fn <- args[1]
   clname <- args[2]
   b <- paste0("../CONVERTF/", fn, ".ind")
   bout <- paste0("../CONVERTF/", fn, "-ald.ind")
   
   # Prepare alternative individual files with ethnicity status
   f <- read.table("../EIGENSTRAT/merged.pca.evec", header= T, as.is=T)
   eth <- f[,c("Sample",clname)]
   ind <- read.table(b, col.names=c("Sample","Sex",clname), header=F)
   ind_eth <- merge(ind,eth,by="Sample")
   write.table(ind_eth[,-c(3)], bout, col.names=F, row.names=F, quote=F, sep=" ")
}
