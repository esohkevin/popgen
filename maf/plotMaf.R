#!/usr/bin/Rscript

desBin <- read.table("freqs.txt", col.names=c("bin","bin1", "bin2", "bin3", 
					      "bin4", "bin5", "bin6", "bin7", 
					      "bin8", "bin9", "bin10"), as.is=T)

png("maf.png", height=600, width=600, units="px", type="cairo", points=14)
barplot(as.matrix(desBin[,2:ncol(desBin)]), beside=T, col=c("red", "blue", "green"))
legend("topright", c("all", "nonsynonymous", "synonymous"), fill = c("red", "blue", "green"), bty="n")
dev.off()
