#!/usr/bin/Rscript

############### PER INDIVIDUAL QC ######################
### Plot Heterozygosity vs Missingness
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
png(filename = "mishet.png", width = 500, height = 480, units = "px", pointsize = 14,
    bg = "white",  res = NA)
par(mfrow=c(1,1))
plot(mishet$het.rate, mishet$mis.rate, xlab = "Heterozygous rate", ylab = "Proportion of missing genotype", main="Sample Missingness", pch=20)
abline(v=0.05, h=0.1, lty=2)
dev.off()

# Extract individuals that will be excluded from further analysis (who didn't pass the filter)
# Individuals with mis.rate > 0.1 (10% missingness)
fail_mis_qc=mishet[mishet$mis.rate > 0.10, ]
write.table(fail_mis_qc[,1:2], file = "fail-mis.qc", row.names = F, col.names = F, quote = F, sep = "\t")

# Individuals with outlying het
fail_het_qc=mishet[mishet$het.rate > 0.05, ]
write.table(fail_het_qc[,1:2], file = "fail-het.qc", row.names = F, col.names = F, quote = F, sep = "\t")

