#!/bin/bash

#--- Run Entire PopGen Pipeline

cd qc/
./qc-pipeline.sh ../raw/pass_core_bi_Pf3D7_all_v3_updated.vcf.gz 0 0.05 0.05 0.05

./check_ref.sh pass_bi_core_Pf3D7_all_v3_updated.vcf.gz tref_checked

./beaglePhase.sh qc/pass_bi_core_Pf3D7_all_v3_updated_qc.vcf.gz bipcore


