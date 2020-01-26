#!/usr/bin/Rscript

################# IBD Calculation ###########################
genome=read.table("genome.genome", header = T, as.is = T)
genome=genome[genome$PI_HAT > 0.1875, ]

# Compute mean IBD
mean_ibd=0*genome$Z0 + 1*genome$Z1 + 2*genome$Z2

# Compute the variance of IBD
var.ibd=((0 - mean_ibd)^2)*genome$Z0 +
  ((1 - mean_ibd)^2)*genome$Z1 +
  ((2 - mean_ibd)^2)*genome$Z2

# Compute standard error
se.ibd=sqrt(var.ibd)
#png("ibd_analysis.png", res=1200, height = 5, width = 6, units = "in")
png(filename = "ibd_analysis.png", width = 480, height = 700, units = "px", pointsize = 12,
    bg = "white",  res = NA)
par(mfrow=c(2,1)) # Set parameters to plot ibd_analysis and ibd_se
plot(mean_ibd, se.ibd, xlab = "Mean IBD", ylab = "SE IBD", pch=20, main = "SE IBD of Pairs with Pi HAT > 0.1875")
plot(genome$Z0, genome$Z1, col=1, ylab = "Z1", xlab = "Z0", pch=20)
dev.off()

duplicate1=genome[mean_ibd == 2, ] # monozygotic twins
#duplicate1 # Result: 0. There are no monozygotic twins although the plot shows a close call. These must be duplicates
duplicate2=genome[mean_ibd > 1.98, ] # Equivalent to Z2 > 0.98. Apparently, there were no monozygotic twins but duplicates

write.table(duplicate2, file = "duplicates.txt", col.names = T, row.names = F, quote = F)
sibs=genome[mean_ibd == 1, ]

# Extract IDs of the duplicate pairs and check in the original data set to see which have a lower call rate)
write.table(duplicate2[,1:2], file = "duplicate.ids1", col.names = F, row.names = F, quote = F, sep = "\t")
write.table(duplicate2[,3:4], file = "duplicate.ids2", col.names = F, row.names = F, quote = F, sep = "\t") # Has the higer missingness


