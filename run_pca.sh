#!/bin/bash

source config.sh

pop="$HOME/Git/popgen/"
raw="${pop}raw/"
qc="${pop}qc/"
eig="${pop}eig/"
# QC and Phasing
cd $qc
${qc}qc-pipeline.sh ${raw}pass_core_bi_Pf3D7_all_v3_updated.vcf.gz 0 0.05 0.05 0.05

source beaglePhase.sh
beaglePhase pass_core_bi_Pf3D7_all_v3_updated_qc.vcf.gz passbicore_phased

# PCA and FST estimation
cd ${eig}
./run_eigstruct.sh > eig.log; grep -i -e "ERROR" -e "warning"

