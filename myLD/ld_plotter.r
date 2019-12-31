## R script to plot LD by CP group, and bootstraps for CI
## Started 5 November 2015
## Christian Parobek

####################################
######### DEFINE FUNCTIONS #########
####################################

# Function calculates distance, plots a decay line
plot.bin <- function(LDdf, nbins, binsize, color) {
  
  offset <- binsize - 1
  
  LDdf$diff <- LDdf$POS2-LDdf$POS1 # calculate the distance for each SNP
  #sorted <- LDdf[order(LDdf$diff),] # sort it
  
  xline <- NULL
  yline <- NULL
  
  for (window in 1:nbins*binsize) {
    xline <- append(xline, window)
    yline <- append(yline, mean(LDdf[LDdf$diff >= offset & LDdf$diff < window,]$R.2, na.rm = TRUE))
  }
  lines(xline, yline, col = color, lwd = 3)
}

# Function calculates distance, sorts, fits a regression, and plots
plot.fit <- function(LDdf, deg_poly, color) {
  
  LDdf$diff <- LDdf$POS2-LDdf$POS1 # calculate the distance for each SNP
  sorted <- LDdf[order(LDdf$diff),] # sort it
  fit <- lm(sorted$R.2 ~ poly(sorted$diff, deg_poly, raw=TRUE))
  lines(sorted$diff, predict(fit, data.frame(x=sorted$diff)), col=color)
  
} 

# Function plots a shaded curve following min and max boot values
plot.boot <- function(bootstrap_files, nbins, binsize, shadecolor) {
  
  bootvalues <- unlist(lapply(bootstrap_files, function(x) mean(x$R.2, na.rm = TRUE)))
  the_max <- which.max(bootvalues)
  the_min <- which.min(bootvalues)
  
  xline <- NULL
  for (window in 1:nbins*binsize) {
    xline <- append(xline, window)
  }
  
  upper <- boot.outline(bootstrap_files[[the_max]], nbins, binsize)
  lower <- boot.outline(bootstrap_files[[the_min]], nbins, binsize)
  
  polygon(c(xline, rev(xline)), c(upper, rev(lower)), col = shadecolor, border = NA)
}

# Function selects biggest and smallest bootstrap rep. Use if entire bootstrap dataset is too big.
boot.slimmer <- function(bootstrap_files) {
  
  bootvalues <- unlist(lapply(bootstrap_files, function(x) mean(x$R.2, na.rm = TRUE)))
  the_max <- which.max(bootvalues)
  the_min <- which.min(bootvalues)
  
  bootstrap_slimmed <- list(bootstrap_files[[the_max]], bootstrap_files[[the_min]])
  return(bootstrap_slimmed)
} 

# Accessory function to plot.boot - returns a vector of r2 values
boot.outline <- function(LDdf, nbins, binsize) {
  
  offset <- binsize - 1
  
  LDdf$diff <- LDdf$POS2-LDdf$POS1 # calculate the distance for each SNP
  #sorted <- LDdf[order(LDdf$diff),] # sort it
  
  yline <- NULL
  
  for (window in 1:nbins*binsize) {
    yline <- append(yline, mean(LDdf[LDdf$diff >= offset & LDdf$diff < window,]$R.2, na.rm = TRUE))
  }
  return(yline)
}


####################################
############ INPUT DATA ############
####################################

#for (i in 1:14) {
#   ld <- ''
#   f <- paste0("pointestimates/ld/chr",i,".ld.1-100000.hap.ld")
#   print(paste0("Now Loading chromosome ",i), quote=F)
#   ld[i] <- read.table(f, header = TRUE)
#   ld[i]$R.2[is.nan(ld[i]$R.2)] <- 1
   ld1 <- read.table("pointestimates/ld/chr1.ld.1-100000.hap.ld", header = TRUE)
   ld2 <- read.table("pointestimates/ld/chr2.ld.1-100000.hap.ld", header = TRUE)
   ld3 <- read.table("pointestimates/ld/chr3.ld.1-100000.hap.ld", header = TRUE)
   ld4 <- read.table("pointestimates/ld/chr4.ld.1-100000.hap.ld", header = TRUE)
   ld5 <- read.table("pointestimates/ld/chr5.ld.1-100000.hap.ld", header = TRUE)
   ld6 <- read.table("pointestimates/ld/chr6.ld.1-100000.hap.ld", header = TRUE)
   ld7 <- read.table("pointestimates/ld/chr7.ld.1-100000.hap.ld", header = TRUE)
   ld8 <- read.table("pointestimates/ld/chr8.ld.1-100000.hap.ld", header = TRUE)
   ld9 <- read.table("pointestimates/ld/chr9.ld.1-100000.hap.ld", header = TRUE)
   ld10 <- read.table("pointestimates/ld/chr10.ld.1-100000.hap.ld", header = TRUE)
   ld11 <- read.table("pointestimates/ld/chr11.ld.1-100000.hap.ld", header = TRUE)
   ld12 <- read.table("pointestimates/ld/chr12.ld.1-100000.hap.ld", header = TRUE)
   ld13 <- read.table("pointestimates/ld/chr13.ld.1-100000.hap.ld", header = TRUE)
   ld14 <- read.table("pointestimates/ld/chr14.ld.1-100000.hap.ld", header = TRUE)
#}
ldpv <- read.table("pointestimates/ld/chr1.ld.1-100000.hap.ld", header = TRUE)

# optional to convert NaN to 1
ld1$R.2[is.nan(ld1$R.2)] <- 1
ld2$R.2[is.nan(ld2$R.2)] <- 1
ld3$R.2[is.nan(ld3$R.2)] <- 1
ld4$R.2[is.nan(ld4$R.2)] <- 1
ld5$R.2[is.nan(ld5$R.2)] <- 1
ld6$R.2[is.nan(ld6$R.2)] <- 1
ld7$R.2[is.nan(ld7$R.2)] <- 1
ld8$R.2[is.nan(ld8$R.2)] <- 1
ld9$R.2[is.nan(ld9$R.2)] <- 1
ld10$R.2[is.nan(ld10$R.2)] <- 1
ld11$R.2[is.nan(ld11$R.2)] <- 1
ld12$R.2[is.nan(ld12$R.2)] <- 1
ld13$R.2[is.nan(ld13$R.2)] <- 1
ld14$R.2[is.nan(ld14$R.2)] <- 1


bootstrap_names <- list.files("bootstrap/ld", pattern="*hap.ld", full.names=TRUE)
bootstrap_files <- lapply(bootstrap_names, read.table, header = TRUE)


####################################
############# PLOT IT ##############
####################################

## Setup plot coordinates
plot(ld2$POS2-ld2$POS1, ld2$R.2, 
     type = "n", xlim = c(0,100000), axes = FALSE, 
     xlab = "Pairwise Coordinate Distance", ylab = expression(italic(r^2)))
axis(1, at = c(0, 25000, 50000, 75000, 100000))
axis(2, las = 2)

## Slim bootstraps
slimboot <- boot.slimmer(bootstrap_files)
remove(bootstrap_files)

## Plot bootstraps
plot.boot(slimboot, 200, 1000, "lightgray") # plot shaded outline of max and min

## Plot pointestimates
require(colorspace)
pcol <- qualitative_hcl(14, "Dark2")

#for (i in 1:14) {
#   plot.bin(ld[1], 200, 1000, pcol[i])
   plot.bin(ld1, 200, 1000, "cadetblue1")
   plot.bin(ld2, 200, 1000, "firebrick3")
   plot.bin(ld3, 200, 1000, "red")
   plot.bin(ld4, 200, 1000, "goldenrod2")
   plot.bin(ld5, 200, 1000, "cadetblue1")
   plot.bin(ld6, 200, 1000, "firebrick3")
   plot.bin(ld7, 200, 1000, "red")
   plot.bin(ld8, 200, 1000, "goldenrod2")
   plot.bin(ld9, 200, 1000, "cadetblue1")
   plot.bin(ld10, 200, 1000, "firebrick3")
   plot.bin(ld11, 200, 1000, "red")
   plot.bin(ld12, 200, 1000, "goldenrod2")
   plot.bin(ld13, 200, 1000, "cadetblue1")
   plot.bin(ld14, 200, 1000, "firebrick3")

#}
legend(80000, 0.55, 
       legend = c("CP1", "CP2", "CP4", "Bootstraps"),
       col = c(1:14), 
       #col = c("cadetblue1", "firebrick3", "goldenrod2", "gray"), 
       lty=c(1, 1, 1, 1),
       lwd = 3)
