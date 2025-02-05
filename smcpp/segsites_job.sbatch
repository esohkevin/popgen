#!/usr/bin/env bash
#SBATCH --account=humgen
#SBATCH --partition=sadacc-long
#SBATCH --nodes=1 --ntasks=1 --cpus-per-task=1
#SBATCH --time=200:00:00
#SBATCH --job-name="segsites"
#SBATCH --mail-user=eshkev001@myuct.ac.za
#SBATCH --mail-type=END,FAIL
#SBATCH --output=nextflow_%j.log
pwd; hostname; date

module load software/nextflow-21.10.6
module load java/jdk-11
#module load mpi/openmpi-4.1.0-sadacc

cd /home/eshkev001/workflows/smcpp

#for i in {1..20}; do nextflow clean -f; done

#rm -rf /scratch/eshkev001/projects/scdpopgen/smcpp/work

nextflow run getsegregatingsites.nf -w /scratch/eshkev001/projects/scdpopgen/smcpp/work/ -profile ucthpc -resume

