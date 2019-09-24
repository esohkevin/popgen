#!/usr/bin/Rscript

#setwd("~/Git/popgen/eig/EIGENSTRAT/")
#fn <- "passbicore.pca.evec"

#--------- Save evec data into placeholder
require(colorspace)

args <- commandArgs(TRUE)
fm <- args[1]
fn <- paste(fm, ".pca.evec", sep="")
out <- paste0(fm, ".png")

plaf_pca <- read.table(fn, header=F, as.is=T)

if (ncol(plaf_pca) == 12) {
  colnames(plaf_pca) <- c("Sample","PC1","PC2","PC3","PC4","PC5",
                          "PC6","PC7","PC8","PC9","PC10","Pop")
} else {
  colnames(plaf_pca) <- c("Sample","PC1","PC2","PC3","PC4","PC5","Pop")
}

#--------- Merge pca and pheno files
pheno <- read.table("../CONVERTF/pheno.txt", header=T)
plaf_merge <- merge(plaf_pca, pheno, by="Sample")
attach(plaf_merge)

#------ Save a copy of the updated merged file
write.table(plaf_merge, file = "merged.pca.evec", col.names = T, 
            row.names = F, quote = F, sep = '\t')

#----- Factorize all categories of interest
plaf_merge$DAGECAT <- as.factor(plaf_merge$DAGECAT)
plaf_merge$ALTCAT <- as.factor(plaf_merge$ALTCAT)
plaf_merge$Status <- as.factor(plaf_merge$Status)
plaf_merge$DSEX <- as.factor(plaf_merge$DSEX)
plaf_merge$PARACAT <- as.factor(plaf_merge$PARACAT)

#---Set image parameters
png(out, height = 18, width = 26, units = "cm", res = 100, points = 14)
par(mfrow = c(2,3))

#-------Extract only non-missing data of current categories to plot
#---Age
aged <- na.omit(plaf_merge[plaf_merge$DAGECAT == "Under5" || 
                             plaf_merge$DAGECAT == "MidAge" || plaf_merge$
                             DAGECAT == "Adult", ])

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
#dev.off()

#---Altitude
altd <- na.omit(plaf_merge[plaf_merge$ALTCAT=="High" || 
                             plaf_merge$ALTCAT=="Moderate" || 
                             plaf_merge$ALTCAT=="LOW", ])

alt_lev <- levels(plaf_merge$ALTCAT)
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
legend("topright",
       legend=levels(altd$ALTCAT),
       col=popcol,
       pch=20,
       bty="l",
       horiz = F,
       cex = 0.8)
#dev.off()

#---Status (uncomplicated and asymptomatic)
stat <- na.omit(plaf_merge[plaf_merge$Status=="UM" || 
                             plaf_merge$Status=="AP",])

stat_lev <- levels(stat$Status)
n <- length(stat_lev)
popcol <- qualitative_hcl(n, "Dark 3")
plot(stat$PC1, stat$PC2, pch = 20, xlab = "PC1",
    main="Colored by Donor Status", ylab = "PC2")
d <- stat[stat$Status == "AP",]
points(d$PC1,d$PC2, col=popcol[1], pch=20)
d <- stat[stat$Status == "UM", ]
points(d$PC1,d$PC2, col=popcol[2], pch=20)
legend("topright",
       legend=levels(stat$Status),
       col=popcol,
       pch=20,
       bty="l",
       horiz = F,
       cex = 0.8)
#dev.off()

#---Parasitemia
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
legend("topright",
       legend=levels(parat$PARACAT),
       col=popcol,
       pch=20,
       bty="l",
       horiz = F,
       cex = 0.8)
#dev.off()

#---Status (uncomplicated and asymptomatic)
dsex <- na.omit(plaf_merge[plaf_merge$DSEX=="F" || 
                             plaf_merge$DSEX=="M",])

dsex_lev <- levels(plaf_merge$DSEX)
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
dev.off()
