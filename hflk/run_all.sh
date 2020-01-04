#!/bin/bash

./getbim.sh ../qc/passbicore_phased_pca-filtered.vcf.gz 0.2 1 14 ../sample/nonmisALTCAT.ids

bash -i run_hapflk.sh data/nonmisALTCATflk data/nonmisALTCAT_chr 1 14 2 15

./hflkman.R flkout/nonmisALTCAT_chr 14


