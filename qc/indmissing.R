#!/usr/bin/env Rscript

############### PER INDIVIDUAL QC ######################
### Plot Heterozygosity vs Missingness

args <- commandArgs(TRUE)

if (length(args) < 3) {
   print("",quote=F)
   print("Usage: Rscript indmissing.R [Lhet] [Uhet] [out-prefix]", quote=F)
   print("",quote=F)
   print("Lhet: Heterozygosity threshold lower bound",quote=F)
   print("Uhet: Heterozygosity threshold upper bound",quote=F)
   print("Lhet and Uhet should be informed by the 'mishet.png' image produced from the ",quote=F)
   print("image produced from a first time run with Lhet = 0 and Uhet = 1 ",quote=F)
   print("",quote=F)
   quit(save="no")
} else {
lhet <- as.numeric(args[1])
uhet <- as.numeric(args[2])
picout <- paste0(args[3],"_mishet.png")
misout <- paste0(args[3],"_fail-mis.qc")
hetout <- paste0(args[3],"_fail-het.qc")
het=read.table("temp1.het", header = T, as.is = T)
mis=read.table("temp1.imiss", header = T, as.is = T)

# save the file reformatted
write.table(het, file = "temp1.het", col.names = T, row.names = F, quote = F, sep = "\t")
write.table(mis, file = "temp1.imiss", col.names = T, row.names = F, quote = F, sep = "\t")

# Calculate the observed heterozygosity rate per individual by (N(NM) - O(HOM)/N(NM))
mishet=data.frame(FID=het$FID, IID=het$IID, het.rate=(het$N.NM. - het$O.HOM.)/het$N.NM., mis.rate=mis$F_MISS)
#meanhet=mean(mishet$het.rate)
#sdhet=sd(mishet$het.rate, na.rm = F)
#hetupper=meanhet + sdhet*3
#hetlower=meanhet - sdhet*3

# Plot the proportion of missing genotypes and the heterozygosity rate
png(filename = picout, width = 500, height = 480, units = "px", pointsize = 14,
    bg = "white",  res = NA)
par(mfrow=c(1,1))
plot(mishet$het.rate, mishet$mis.rate, xlab = "Heterozygous rate", ylab = "Proportion of missing genotype", main="Sample Missingness", pch=20)
abline(v=c(lhet,uhet), h=0.1, lty=2)
dev.off()

# Extract individuals that will be excluded from further analysis (who didn't pass the filter)
# Individuals with mis.rate > 0.1 (10% missingness)
fail_mis_qc=mishet[mishet$mis.rate > 0.10, ]
write.table(fail_mis_qc[,1:2], file = misout, row.names = F, col.names = F, quote = F, sep = "\t")

# Individuals with outlying het
fail_het_qc=mishet[ mishet$het.rate < lhet | mishet$het.rate > uhet, ]
write.table(fail_het_qc[,1:2], file = hetout, row.names = F, col.names = F, quote = F, sep = "\t")
}
