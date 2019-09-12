#!/usr/bin/Rscript

pheno_file <- read.table("../../plaf_pheno.txt", header=T, as.is=T, fill = T)
colnames(pheno_file) <- c("Sample","SC","REG","TWN","DNACD","DNAEX",
			  "PARA","DAGE","DSEX","GPS","Status","ALT","ALTCAT")

attach(pheno_file)

#----- Make Age Categories
pheno_file$DAGE <- as.numeric(DAGE)
pheno_file$DAGECAT <- ifelse(DAGE <= 60, "Under5",
                             ifelse(DAGE > 60 &
                                      DAGE < 216, "MidAge",
                                    ifelse(DAGE >= 216, "Adult",
                                           "NA")))

#----- Make Parasitemia Categories
pheno_file$PARA <- as.numeric(PARA)

pheno_file$PARACAT <- ifelse(PARA <= 10000, "Low",
                             ifelse(PARA > 10000 &
                                      PARA < 250000, "Moderate",
                                    ifelse(PARA >= 250000, "High",
                                           "NA")))

#----- Make Gender Categories
pheno_file$DSEX <- ifelse(DSEX == "Female", "F",
                             ifelse(DSEX == "Male", "M", 
                                    "NA"))

write.table(pheno_file, file = "pheno.txt", col.names=T, row.names=F, quote=F, sep='\t')
