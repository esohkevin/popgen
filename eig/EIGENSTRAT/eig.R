#!/usr/bin/Rscript

#setwd("~/Git/popgen/eig/EIGENSTRAT/")
#fn <- "passbicore.pca.evec"

#--------- Save evec data into placeholder
require(colorspace)
args <- commandArgs(TRUE)
fn <- args[1]
out_plot1 <- paste(args[1], "1.png", sep="")
out_plot2 <- paste(args[1], "2.png", sep="")
out_plot3 <- paste(args[1], "3.png", sep="")

plaf_pca <- read.table(fn, header=F, as.is=T)

if (ncol(plaf_pca == 12)) {
  colnames(plaf_pca) <- c("Sample","PC1","PC2","PC3","PC4","PC5",
                          "PC6","PC7","PC8","PC9","PC10","Pop")
} else {
  colnames(plaf_pca) <- c("Sample","PC1","PC2","PC3","PC4","PC5","Pop")
}

#--------- Merge pca and pheno files
pheno <- read.table("../CONVERTF/pheno.txt", header=T)
plaf_merge <- merge(plaf_pca, pheno, by="Sample")
attach(plaf_merge)


#----- Make Age Categories
plaf_merge$DAGE <- as.numeric(DAGE)
attach(plaf_merge)

plaf_merge$DAGECAT <- ifelse(DAGE <= 60, "UNDER",
                             ifelse(DAGE > 60 &
                                      DAGE < 216, "MID",
                                    ifelse(DAGE >= 216, "ADULT",
                                           "NA")))

#------ Save a copy of the updated merged file
attach(plaf_merge)
write.table(plaf_merge, file = "merged.pca.evec", col.names = T, 
            row.names = F, quote = F, sep = '\t')

#----- Factorize all categories of interest
plaf_merge$DAGECAT <- as.factor(plaf_merge$DAGECAT)
plaf_merge$ALTCAT <- as.factor(plaf_merge$ALTCAT)
plaf_merge$Status <- as.factor(plaf_merge$Status)
plaf_merge$DSEX <- as.factor(plaf_merge$DSEX)
#plaf_merge$PARACAT <- as.factor(plaf_merge$PARACAT)

#-------Extract only non-missing data of current categories to plot
attach(plaf_merge)
#---Age
aged <- na.omit(plaf_merge[DAGECAT == "UNDER" || DAGECAT == "MID" || DAGECAT == "ADULT", ])
attach(aged)
age_lev <- levels(DAGECAT)
n <- length(age_lev)
popcol <- qualitative_hcl(n, "Dark 3")
png("pc-age.png", height = 16, width = 16,
    res = 100, units = "cm", points = 14)
plot(PC1, PC2, pch = 20, xlab = "PC1", 
     main = "PCA colored by Age Group", ylab = "PC2")
d <- aged[DAGECAT == "ADULT",]
points(d$PC1,d$PC2, col=popcol[1], pch=20)
d <- aged[DAGECAT == "MID", ]
points(d$PC1,d$PC2, col=popcol[2], pch=20)
d <- aged[DAGECAT == "UNDER", ]
points(d$PC1,d$PC2, col=popcol[3], pch=20)
legend("topright",
       legend=levels(DAGECAT),
       col=popcol,
       pch=20,
       bty="l",
       horiz = F,
       cex = 0.8)
dev.off()

#---Altitude
attach(plaf_merge)
altd <- na.omit(plaf_merge[ALTCAT=="High" || ALTCAT=="Moderate" || ALTCAT=="LOW", ])
attach(altd)
alt_lev <- levels(ALTCAT)
n <- length(alt_lev)
popcol <- qualitative_hcl(n, "Dark 3")
png("pc-altd.png", height = 16, width = 16,
    res = 100, units = "cm", points = 14)
plot(PC1, PC2, pch = 20, xlab = "PC1",
    main="PCA colored by Altitude", ylab = "PC2")
d <- altd[ALTCAT == "High",]
points(d$PC1,d$PC2, col=popcol[1], pch=20)
d <- altd[ALTCAT == "Low", ]
points(d$PC1,d$PC2, col=popcol[2], pch=20)
d <- altd[ALTCAT == "Moderate", ]
points(d$PC1,d$PC2, col=popcol[3], pch=20)
legend("topright",
       legend=levels(ALTCAT),
       col=popcol,
       pch=20,
       bty="l",
       horiz = F,
       cex = 0.8)
dev.off()

#---Status (uncomplicated and asymptomatic)
attach(plaf_merge)
stat <- na.omit(plaf_merge[Status=="UM" || Status=="AP",])
attach(altd)
stat_lev <- levels(Status)
n <- length(stat_lev)
popcol <- qualitative_hcl(n, "Dark 3")
png("pc-stat.png", height = 16, width = 16,
    res = 100, units = "cm", points = 14)
plot(PC1, PC2, pch = 20, xlab = "PC1",
    main="PCA colored by Donor Status", ylab = "PC2")
d <- stat[Status == "AP",]
points(d$PC1,d$PC2, col=popcol[1], pch=20)
d <- stat[Status == "UM", ]
points(d$PC1,d$PC2, col=popcol[2], pch=20)
#d <- stat[Status == "Moderate", ]
#points(d$PC1,d$PC2, col=popcol[3], pch=20)
legend("topright",
       legend=levels(Status),
       col=popcol,
       pch=20,
       bty="l",
       horiz = F,
       cex = 0.8)
dev.off()

#---Parasitemia
#attach(plaf_merge)
#parat <- na.omit(plaf_merge[PARACAT=="High" || PARACAT=="Moderate" || PARACAT=="LOW", ])
#attach(parat)
#parat_lev <- levels(PARACAT)
#n <- length(parat_lev)
#popcol <- qualitative_hcl(n, "Dark 3")
#png("pc-paracat.png", height = 16, width = 16,
#    res = 100, units = "cm", points = 14)
#plot(PC1, PC2, pch = 20, xlab = "PC1",
#    main="PCA colored by Parasitemia Category", ylab = "PC2")
#d <- parat[PARACAT == "High",]
#points(d$PC1,d$PC2, col=popcol[1], pch=20)
#d <- parat[PARACAT == "Low", ]
#points(d$PC1,d$PC2, col=popcol[2], pch=20)
#d <- parat[PARACAT == "Moderate", ]
#points(d$PC1,d$PC2, col=popcol[3], pch=20)
#legend("topright",
#       legend=levels(PARACAT),
#       col=popcol,
#       pch=20,
#       bty="l",
#       horiz = F,
#       cex = 0.8)
#dev.off()


