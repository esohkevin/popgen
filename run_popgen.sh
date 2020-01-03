#!/bin/bash

#--- Run Entire PopGen Pipeline

cd qc/

qc-pipeline.sh ../pass_bi_core_Pf3D7_all_v3_updated.vcf.gz 0.5 0.01 0.05

cd ../

./check_ref.sh qc/pass_bi_core_Pf3D7_all_v3_updated.vcf.gz tref_checked

./beaglePhase.sh qc/pass_bi_core_Pf3D7_all_v3_updated_qc.vcf.gz bipcore


