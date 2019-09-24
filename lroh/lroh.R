#!/usr/bin/Rscript

merge_lroh <- function(lroh.name = LROH_root_file_name, num.chr = number_of_chromosomes) {
    lroh_col_names <- names(paste(lroh.name,"1",".LROH",sep=""))
    for (chr in 1:num.chr) {
	      each_lroh_base <- paste(lroh.name,chr,".LROH",sep="")
	      each_lroh <- read.table(each_lroh_base, header = T)
	      if (chr==1){lroh <- each_lroh}else{lroh <- rbind(lroh,each_lroh)}
	      #colnames(lroh) <- lroh_col_names
    }
    
    print(data.frame(lroh))
}

