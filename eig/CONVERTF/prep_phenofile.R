#!/usr/bin/Rscript

pheno_file <- read.table("../../plaf_pheno_pdna.txt", header=T, as.is=T, fill = T)
colnames(pheno_file) <- c("Sample","SC","REG","TWN","DNACD","DNAEX",
			  "PARA","DAGE","DSEX","GPS","Status","ALT","ALTCAT")
write.table(pheno_file, file = "pheno.txt", col.names=T, row.names=F, quote=F, sep='\t')
