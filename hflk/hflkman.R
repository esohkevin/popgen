#!/usr/bin/env Rscript

args <- commandArgs(TRUE)
if (length(args) < 2) {
   print("",quote=F)
   print("Usage: ./hflkman.R [data-file-prfx] [#CHR]",quote=F)
   print("#CHR: Number of chromosomes",quote=F)
   quit(save="no")
} else {
   ff <- args[1]
   ffb <- basename(ff)
   nchr <- args[2]
   require(data.table)
   require(qqman)
   #--- hapFLK manhattan plots for chr1-22
   for (i in 1:nchr) {
     #-- Load FLK stats
     f <- fread(paste0(ff,i,"flk.flk"), data.table=F, h=T)
     if(i==1){flk<-f}else{flk<-rbind(flk,f)}
   
     #-- Load hapFLK stats
     h <- fread(paste0(ff,i,"flk.hapflk"), data.table=F, h=T)
     if(i==1){hflk<-h}else{hflk<-rbind(hflk,h)}
   
     #-- Load scaled hapFLK (with pvalues) stats
     s <- fread(paste0(ff,i,"flk.hapflk_sc"), data.table=F, h=T)
     if(i==1){sflk<-s}else{sflk<-rbind(sflk,s)}
   }
   
   #-- Compute Threshold for FLK stats
   ns <- length(flk$pos)
   print("", quote=F)
   print(paste0("Effive number of SNPs: ", ns), quote=F)
   print("", quote=F)
   thr <- as.numeric(-log10(0.05/ns))
   print(paste0("Genome-wide threshold: ", thr), quote=F)
   print("", quote=F)
   
   if (thr >= 8) {
   	thresh <- 8
   } else {thresh <- thr}
   
   #--- Write table of scaled hapFLK results
   osflk <- paste0("scaledhFLK_",gsub("_chr","",ffb),".txt")
   fwrite(sflk, osflk, buffMB = 10, nThread = 30, sep = " ")
   
   #--- Plot scaled hFLK
   ohflk <- paste0(gsub("_chr","",ff),".hflk.png")
   png(ohflk, height=580, width=650, units="px", res=NA, pointsize= 12)
   #par(mfrow=c(2,1))
   #par(fig=c(0,1,0,0.50), bty="o", mar=c(5,4,2,1))
   layout(matrix(1:2,2,1))
   #--- Scaled hapFLK manhattan
   manhattan(sflk, chr = "chr", bp = "pos", 
             p = "pvalue", snp = "rs",
             col = c("grey10", "grey60"), 
             genomewideline = thresh,
   	  highlight = sflk$rs[-log10(sflk$pvalue)>=-log10(1E-5)], 
             suggestiveline = -log10(1E-5))
   #par(fig=c(0,1,0.50,1), new=T, bty="o", mar=c(0,4,2,1))
   #--- hapFLK manhattan
   manhattan(hflk, chr = "chr", bp = "pos", 
             p = "hapflk", snp = "rs",
             col = c("grey10", "grey60"), 
             logp=F, type='l', lwd=2, #xaxt='n', 
             genomewideline = F, 
             suggestiveline = F, ylab = "hapFLK")
   dev.off()
   
   # #--- hapFLK manhattan
   ohflks <- paste0(gsub("_chr","",ff),".hflk.single.png")
   png(ohflks, height=320, width=650, units="px", res=NA, pointsize= 12)
   manhattan(sflk, chr = "chr", bp = "pos",
             p = "pvalue", snp = "rs",
             col = c("grey10", "grey60"),
             genomewideline = thresh,
             highlight = sflk$rs[-log10(sflk$pvalue)>=-log10(1E-5)],
             suggestiveline = -log10(1E-5))
   dev.off()
}
