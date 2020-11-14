setwd("~/Desktop/")

pfile <- "bw.1kgp.samples.txt"
#efile <- "bw.hiv.eigenvec"
efile <- "MERGED.3.evec"

plot.pca <- function(p = pop_file, 
                     e = evec_file,
                     f = out_png_prefix)
{
  fall <- paste0(f,".all.pca.pdf")
  fbot <- paste0(f, ".bw.pca.pdf")
  #-- load required libraries
  require(colorspace)
  require(RColorBrewer)
  
  #-- load data files
  w <-read.table(p, h=F, col.names = c("FID","IID","SEX","ETH","POP"))
  g <-read.table(e, h=T)
  w <- w[-c(2:3)] # exclude IID and SEX columns
  wg <- merge(g, w, by="FID")
  
  u.eth <- unique(levels(wg$ETH)) # get uniq country names as eth
  u.pop <- unique(levels(wg$POP)) # get uniq continent names as pop
  n.eth <- length(u.eth)          # count the number of countries
  n.pop <- length(u.pop)          # count the number of continents
  
  #col1 <- RColorBrewer::brewer.pal(if(n.eth>8){8}else{n.eth}, "Dark2") # define color for each country
  col2 <- RColorBrewer::brewer.pal(if(n.pop>8){8}else{n.pop}, "Set1") # define color for each continent
  
  #u.eth.col <- as.data.frame(u.eth, col2) # make table of country and their colors
  u.pop.col <- as.data.frame(u.pop, col2) # make table of continent and their colors
  
  #-- make column of colors
  #u.eth.col$col <- rownames(u.eth.col)
  u.pop.col$col <- rownames(u.pop.col)
  
  pdf(file = fall, pointsize = 14, colormodel = "cmyk")
  plot(wg$PC1, wg$PC2, xlab = NA, ylab = NA, type = "n", bty = "l", cex.axis=0.7)
  mtext("PC1", side = 1, cex = 0.7, line = 2)
  mtext("PC2", side = 2, cex = 0.7, line = 2)
  
  d <- data.frame()
  
  #-- Plot by continent
  for (pop in u.pop.col$u.pop) {
    d <- wg[wg$POP==pop,]
    points(d$PC1, d$PC2, col = u.pop.col$col[u.pop.col$u.pop==pop], pch = 20)
  }
  
  d <- wg[wg$ETH=="BOT",]
  points(d$PC1, d$PC2, col = "black", pch = 20)
  
  legend("bottomleft", 
         legend = c(levels(u.pop.col$u.pop),"BOT"), 
         col = c(u.pop.col$col,"black"), 
         bty = "n", 
         pch = 20, 
         horiz = T,
         cex = 0.8)
  dev.off()
#  #-- Plot by ethnicity (country)
#  for (eth in u.eth) {
#    if(eth != "BOT") {
#      d <- wg[wg$ETH==eth,]
#      points(d$PC1, d$PC2, pch = 20)
#    } else
#      d <- wg[wg$ETH==eth,]
#    points(d$PC1, d$PC2, pch = 20, col=)
#  }
  pdf(file = fbot, pointsize = 14, colormodel = "cmyk")
  d <- wg[wg$ETH=="BOT",]
  plot(d$PC1, d$PC2, col = "black", pch = 20, xlab=NA, ylab=NA, cex.axis=0.7)
  mtext("PC1", side = 1, line = 2, cex = 0.8)
  mtext("PC2", side = 2, line = 2, cex = 0.8)
  dev.off()
}

plot.pca(p=pfile, e=efile, f="merged")

head(wg)
