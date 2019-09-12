#!/usr/bin/Rscript

#setwd("~/Git/popgen/eig/EIGENSTRAT/")
#fn <- "passbicore.pca.evec"

#------ Load evec files
evec_plot <- function(evec_root = c("agebest","altbest","statbest","parabest","dsexbest"),
                      pheno_file = "pheno.txt",
                      out_name = "pca") {
  
  require(colorspace)
  
  #---Load pheno file
  pheno <- read.table(pheno_file, header=T)
  
  #--Initialize output
  fout <- paste0(out_name, ".png")
  m <- ceiling(length(evec_root)/2)
  png(fout, height = 18, width = 26, units = "cm", res = 100, points = 14)
  par(mfrow = c(2,m))
  
  #---Load each evec file
  for (eroot in evec_root) {
    fn <- read.table(paste0(eroot, ".pca.evec"))
    if (ncol(fn) == 12) {
      colnames(fn) <- c("Sample","PC1","PC2","PC3","PC4","PC5",
                              "PC6","PC7","PC8","PC9","PC10","Pop")
    } else {
      colnames(fn) <- c("Sample","PC1","PC2","PC3","PC4","PC5","Pop")
    }
    
    if (eroot == "alt" || eroot == "altbest") {
      #---Merge evec and pheno files
      plaf_merge <- merge(fn, pheno, by="Sample")
      
      #---Factorize the category
      plaf_merge$ALTCAT <- as.factor(plaf_merge$ALTCAT)
      
      #---Extract only non-missing data the categories and plot
      altd <- na.omit(plaf_merge[plaf_merge$ALTCAT=="High" || 
                                   plaf_merge$ALTCAT=="Moderate" || 
                                   plaf_merge$ALTCAT=="Low", ])
      alt_lev <- levels(altd$ALTCAT)
      n <- length(alt_lev)
      popcol <- qualitative_hcl(n, "Dark 3")
      plot(altd$PC1, altd$PC2, pch = 20, xlab = "PC1",
           main="Colored by Altitude", ylab = "PC2")
      d <- altd[altd$ALTCAT == "High",]
      points(d$PC1,d$PC2, col=popcol[1], pch=20)
      d <- altd[altd$ALTCAT == "Low", ]
      points(d$PC1,d$PC2, col=popcol[2], pch=20)
      d <- altd[altd$ALTCAT == "Moderate", ]
      points(d$PC1,d$PC2, col=popcol[3], pch=20)
      legend("topleft",
             legend=levels(altd$ALTCAT),
             col=popcol,
             pch=20,
             bty="l",
             horiz = F,
             cex = 0.8)
      
    } else if (eroot == "age" || eroot == "agebest") {
      #---Merge evec and pheno files
      plaf_merge <- merge(fn, pheno, by="Sample")
      
      #---Factorize the category
      plaf_merge$DAGECAT <- as.factor(plaf_merge$DAGECAT)
      
      #---Extract only non-missing data the categories and plot
      aged <- na.omit(plaf_merge[plaf_merge$DAGECAT == "Under5" || 
                                   plaf_merge$DAGECAT == "MidAge" || 
                                   plaf_merge$DAGECAT == "Adult", ])
      age_lev <- levels(aged$DAGECAT)
      n <- length(age_lev)
      popcol <- qualitative_hcl(n, "Dark 3")
      plot(aged$PC1, aged$PC2, pch = 20, xlab = "PC1", 
           main = "Colored by Donor Age Group", ylab = "PC2")
      d <- aged[aged$DAGECAT == "Adult",]
      points(d$PC1,d$PC2, col=popcol[1], pch=20)
      d <- aged[aged$DAGECAT == "MidAge", ]
      points(d$PC1,d$PC2, col=popcol[2], pch=20)
      d <- aged[aged$DAGECAT == "Under5", ]
      points(d$PC1,d$PC2, col=popcol[3], pch=20)
      legend("topright",
             legend=levels(aged$DAGECAT),
             col=popcol,
             pch=20,
             bty="l",
             horiz = F,
             cex = 0.8)
      
    } else if (eroot == "stat" || eroot == "statbest") {
      #---Merge evec and pheno files
      plaf_merge <- merge(fn, pheno, by="Sample")
     
      #---Factorize the category
      plaf_merge$Status <- as.factor(plaf_merge$Status)
      
      #---Extract only non-missing data the categories and plot
      stat <- na.omit(plaf_merge[plaf_merge$Status == "AP" || 
                                   plaf_merge$Status == "UM", ])
      stat_lev <- levels(stat$Status)
      n <- length(stat_lev)
      popcol <- qualitative_hcl(n, "Dark 3")
      plot(stat$PC1, stat$PC2, pch = 20, xlab = "PC1", 
           main = "Colored by Donor Status", ylab = "PC2")
      d <- stat[stat$Status == "AP",]
      points(d$PC1,d$PC2, col=popcol[1], pch=20)
      d <- stat[stat$Status == "UM", ]
      points(d$PC1,d$PC2, col=popcol[2], pch=20)
      legend("topleft",
             legend=levels(stat$Status),
             col=popcol,
             pch=20,
             bty="l",
             horiz = F,
             cex = 0.8)
      
    } else if (eroot == "dsex" || eroot == "dsexbest") {
      #---Merge evec and pheno files
      plaf_merge <- merge(fn, pheno, by="Sample")
     
      #---Factorize the category
      plaf_merge$DSEX <- as.factor(plaf_merge$DSEX)
      
      #---Extract only non-missing data the categories and plot
      dsex <- na.omit(plaf_merge[plaf_merge$DSEX=="F" || 
                                   plaf_merge$DSEX=="M",])
      dsex_lev <- levels(dsex$DSEX)
      n <- length(dsex_lev)
      popcol <- qualitative_hcl(n, "Dark 3")
      plot(dsex$PC1, dsex$PC2, pch = 20, xlab = "PC1",
           main="Colored by Donor Gender", ylab = "PC2")
      d <- dsex[dsex$DSEX == "F",]
      points(d$PC1,d$PC2, col=popcol[1], pch=20)
      d <- dsex[dsex$DSEX == "M", ]
      points(d$PC1,d$PC2, col=popcol[2], pch=20)
      legend("topright",
             legend=levels(dsex$DSEX),
             col=popcol,
             pch=20,
             bty="l",
             horiz = F,
             cex = 0.8)
      
    } else if (eroot == "para" || eroot == "parabest") {
      #---Merge evec and pheno files
      plaf_merge <- merge(fn, pheno, by="Sample")
      
      #---Factorize the category
      plaf_merge$PARACAT <- as.factor(plaf_merge$PARACAT)
      
      #---Extract only non-missing data the categories and plot
      parat <- na.omit(plaf_merge[plaf_merge$PARACAT=="High" || 
                                    plaf_merge$PARACAT=="Moderate" || 
                                    plaf_merge$PARACAT=="Low", ])
      parat_lev <- levels(parat$PARACAT)
      n <- length(parat_lev)
      popcol <- qualitative_hcl(n, "Dark 3")
      plot(parat$PC1, parat$PC2, pch = 20, xlab = "PC1",
           main="Colored by Parasitemia", ylab = "PC2")
      d <- parat[parat$PARACAT == "High",]
      points(d$PC1,d$PC2, col=popcol[1], pch=20)
      d <- parat[parat$PARACAT == "Low", ]
      points(d$PC1,d$PC2, col=popcol[2], pch=20)
      d <- parat[parat$PARACAT == "Moderate", ]
      points(d$PC1,d$PC2, col=popcol[3], pch=20)
      legend("topleft",
             legend=levels(parat$PARACAT),
             col=popcol,
             pch=20,
             bty="l",
             horiz = F,
             cex = 0.8)
    } 
  }
  dev.off()
  print("You have chosen to save the PCA image as", quote = F)
  return(fout)
}


#evec_plot(evec_root = c("agebest","altbest","statbest","parabest"), pheno_file = "../CONVERTF/pheno.txt")

