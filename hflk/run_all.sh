#!/bin/bash

for i in ../sample/nonmisStatus.ids ../sample/nonmisDAGECAT.ids ../sample/nonmisDSEX.ids ../sample/nonmisPARACAT.ids; do
   
   bname=$(basename ${i/.ids/})
   ./getbim.sh ../qc/passbicore_phased_pca-filtered.vcf.gz 0.2 1 14 $i
   
   bash -i run_hapflk.sh data/${bname}flk data/${bname}_chr 1 14 5 15
   
   ./hflkman.R flkout/${bname}_chr 14
done
