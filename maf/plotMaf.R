#!/usr/bin/Rscript

args <- commandArgs(TRUE)

if (length(args) < 2) {
   print("",quote=F)
   print("Usage: plotHist.R [freq-file] [out-png] ",quote=F)
   print("",quote=F)
   quit(save="no")
} else {
   require(colorspace)
   f <- args[1]
   p <- args[2]   
   desBin <- read.table(f, col.names=c("bin","bin1", "bin2", "bin3", 
   					      "bin4", "bin5", "bin6", "bin7", 
   					      "bin8", "bin9", "bin10"), as.is=T)
   
   png(p, height=600, width=600, units="px", type="cairo", points=14)
   barplot(as.matrix(desBin[,2:ncol(desBin)]), 
	   beside=T, 
	   col=c("red", "blue"), 
	   ylab="MAF", 
	   xlab="MAFbin",
	   cex.axis=0.8)
   legend("topright", 
	  c("synonymous", "nonsynonymous"), 
	  fill = c("red", "blue"), 
	  bty="n")
   dev.off()
}
