#!/bin/bash

./getbim.sh ../qc/passbicore_phased_pca-filtered.vcf.gz 0.2 1 14 ../sample/nonmisPARACAT.ids

bash -i run_hapflk.sh data/nonmisPARACATflk data/nonmisPARACAT_chr 1 14 2 15
