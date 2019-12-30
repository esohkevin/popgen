#!/usr/bin/env Rscript

args <- commandArgs(TRUE)
ind <- args[1]

# Prepare alternative individual files with ethnicity status
eth <- read.table("../CONVERTF/pheno.txt", header = T, as.is=T)
eigAnceMapInd <- read.table(ind, col.names=c("Sample", "SEX", "Status"), as.is=T)
eigAnceMapIndNoStatus <- data.frame(FID=eigAnceMapInd[,1], SEX=eigAnceMapInd[,2])
neweth <- merge(eigAnceMapIndNoStatus, eth, by="Sample")
#write.table(neweth, file="../CONVERTF/qc-camgwas-eth.txt", col.names=T, row.names=F, quote=F)

# With region of sample collection
region <- read.table("../CONVERTF/pheno.txt", col.names=c("Sample", "IID", "PARACAT"), as.is=T)
regionNoIID <- data.frame(FID=region[,1], REGION=region[,3])
newregion <- merge(eigAnceMapIndNoStatus, regionNoIID, by="FID")
#write.table(newregion, file="../CONVERTF/qc-camgwas-reg.txt", col.names=T, row.names=F, quote=F)
