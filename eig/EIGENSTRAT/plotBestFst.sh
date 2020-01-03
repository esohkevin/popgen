#!/bin/bash

Rscript -e 'source("~/Git/popgen/eig/EIGENSTRAT/eig-fst.R"); evec_plot(evec_root = c("agebest","altbest","statbest","parabest","dsexbest"), pheno_file = "../CONVERTF/pheno.txt", out_name = "pca-fst-PC1vPC2")'
