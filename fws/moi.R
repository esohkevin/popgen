#!/usr/bin/Rscript

setwd("~/Git/popgen/fws/")

library(SeqArray)
library(colorspace)
#----Convert VCF tp GDS
#seqVCF2GDS("moi.vcf.gz", "moi.gds")

#----Open GDS file
isolates <- seqOpen("moi.gds")

#----Get summary of file
seqSummary(isolates)  

#----Save sample iDs
sample.id <- seqGetData(isolates, "sample.id")

library(moimix)

#----Get coordinates
coords <- getCoordinates(isolates)
head(coords)

isolate_baf <- bafMatrix(isolates)
class(isolate_baf)

str(isolate_baf)
baf_frame <-  as.data.frame(isolate_baf$baf_matrix)
tbaf_frame <- t(baf_frame)
dimnames(isolate_baf$baf_matrix)
barplot(baf_frame)


c <- diverge_hcl(3, h = 200, c = 70, l = 40, power = 1.5, alpha = 0.8)
png("QP0098-C.png", height = 15, width = 18, res = 100, units = "cm", points = 14)
for (i in sample.id) {
    plot(isolate_baf, i, add = T, main = i)
}

dev.off()

set.seed(2002)
counts <- alleleCounts(isolates)
m1 <- binommix(counts, sample.id = "QP0098-C", k = 2)
summary(m1)

fws_all <- getFws(isolates)

png("fwsHist.png", height = 16, width = 16, res = 100, units = "cm", points = 14)
hist(fws_all)
dev.off()

for (i in sample.id) {
  
}
fws_all["QP0098-C"] < 0.95
#fws_all[1:row(fws_all)] < 0.95

#fws_all
