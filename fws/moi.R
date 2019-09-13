#!/usr/bin/Rscript

setwd("~/Git/popgen/fws/")

library(SeqArray)
library(colorspace)
#----Convert VCF tp GDS
seqVCF2GDS("moi.vcf.gz", "moi.gds")

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

plot(isolate_baf, "QP0092-C")

set.seed(2002)
counts <- alleleCounts(isolates)
m1 <- binommix(counts, sample.id = "QP0098-C", k = 2)
summary(m1)

fws_all <- getFws(isolates)

hist(fws_all, col = c)

fws_all["QP0098-C"] < 0.95
fws_all[1:row(fws_all)] < 0.95

fws_all
