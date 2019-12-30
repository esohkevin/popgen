#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

if (length(args) < 2) {
   print("",quote=F)
   print("Usage: flkman.R [tree-file] [flk-result]")
   quit(save="no")
} else {

   tf <- args[1]
   flkr <- args[2]

   require(ape)
   require(qqman)
   require(colorspace)
   require(data.table)
   
   neu.t=read.tree(tf)
   plot(neu.t,align=T)
   axis(1,line=1.5)
   title(xlab='F')
   
   flk <- na.omit(fread(flkr, header=T, data.table = F, nThread = 10))
   flk$BH_adj_P <- p.adjust(flk$pvalue, method = "BH")
   flk$Bonf <- p.adjust(flk$pvalue, method = "bonferroni")
   write.table(flk, file =  gsub(".flk", "_new.flk", flkr), col.names=T, row.names = F, quote = F, sep = " ")
   
   head(flk)
   #--- Colors
   #n <- length(unique(flk$chr))
   #pcol <- qualitative_hcl(n, h=c(0,360*(n-1)/n), c = 80, l = 40)
   
   #--- Make genome-wode threshold
   p <- nrow(flk)
   thresh <- 0.05/p  # genome-wide
   sgl <- -log10(thresh) - 2 # suggestive line
   png(gsub(".flk", "_man.png", flkr), width = 700, height = 480, units = "px", pointsize = 12, res = NA)
   manhattan(flk, chr = "chr", bp = "pos", p = "pvalue", snp = "rs", 
             genomewideline = -log10(thresh), suggestiveline = sgl,
             col = c("grey10", "grey60"),
             highlight = flk$rs[-log10(flk$pvalue)>=sgl], annotatePval = 10^(-sgl),
             annotateTop = T)
   dev.off()
   #--- Q-Q plot
   png(gsub(".flk", "._qq.png", flkr), width = 400, height = 400, units = "px", pointsize = 10, res = NA)
   qq(flk$pvalue)
   dev.off()
   
   #--- Density plot
   #plot(density(flk$flk))
   #hist(flk$flk, n=200, f=F)
   #x <- seq(0,30,0.01)
   #lines(x, dchisq(x, df=2),lwd=2,col=2)
   #dev.off()
}
