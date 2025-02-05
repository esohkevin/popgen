#!/usr/bin/env bash
#SBATCH --account=humgen
#SBATCH --partition=sadacc-long
#SBATCH --nodes=1 --ntasks=1 --cpus-per-task=40
#SBATCH --time=200:00:00
#SBATCH --job-name="pre-smcpp"
#SBATCH --mail-user=eshkev001@myuct.ac.za
#SBATCH --mail-type=END,FAIL
#SBATCH --output=nextflow_%j.log
pwd; hostname; date

module load software/nextflow-21.10.6
module load java/jdk-11
module load software/bcftools-1.9
module load software/samtools-1.14
module load software/plink-2.00a
#module load mpi/openmpi-4.1.0-sadacc

cd /home/eshkev001/workflows/smcpp

#for i in {1..22} X; do 
#  bcftools \
#    index \
#    -ft /scratch/eshkev001/analysis/gwas/tz/clean/chr${i}-aligned-clean.vcf.gz; 
#done

#wget \
#  -c \
#  https://ftp.ensembl.org/pub/current_variation/vcf/homo_sapiens/1000GENOMES-phase_3.vcf.gz \
#  -O /scratch/eshkev001/db/hg38/1000GENOMES-phase_3.vcf.gz
  
#wget \
#  -c \
#  https://ftp.ensembl.org/pub/grch37/current/variation/vcf/homo_sapiens/1000GENOMES-phase_3.vcf.gz
#  -0 /scratch/eshkev001/db/hg19/1000GENOMES-phase_3.vcf.gz

#bcftools \
#  index \
#  -ft \
#  --threads 40 \
#  /scratch/eshkev001/db/hg38/1000GENOMES-phase_3.vcf.gz

#bcftools \
#  index \
#  -ft \
#  --threads 40 \
#  /scratch/eshkev001/db/hg19/1000GENOMES-phase_3.vcf.gz

#bcftools \
#  view \
#  --threads 40 \
#  -i 'INFO/AA!=""' \
#  /scratch/eshkev001/db/hg19/1000GENOMES-phase_3.vcf.gz | \
#bcftools \
#  query \
#  -f '%CHROM\t%POS\t%ID\t%REF\t%ALT\t%INFO/AA\n' | \
#sed '1 i #CHROM\tPOS\tID\tREF\tALT\tANC' | \
#gzip \
#  -c \
#  > /scratch/eshkev001/db/hg19/1000GENOMES-phase_3_ancestral_alleles.txt.gz


cd /scratch/eshkev001/imputationReference/kgp/

#wget \
#  -c \
#  https://www.dropbox.com/s/y6ytfoybz48dc0u/all_phase3.pgen.zst?dl=1 \
#  -O /scratch/eshkev001/imputationReference/kgp/all_phase3.pgen.zst
#
#wget \
#  -c \
#  https://www.dropbox.com/s/odlexvo8fummcvt/all_phase3.pvar.zst?dl=1 \
#  -O /scratch/eshkev001/imputationReference/kgp/all_phase3.pvar.zst
#
#wget \
#  -c \
#  https://www.dropbox.com/s/6ppo144ikdzery5/phase3_corrected.psam?dl=1 \
#  -O /scratch/eshkev001/imputationReference/kgp/all_phase3.psam
#
#plink2 --zst-decompress all_phase3.pgen.zst > all_phase3.pgen
#plink2 --zst-decompress all_phase3.pvar.zst > all_phase3.pvar

plink2 --pfile all_phase3 --king-cutoff 0.05 --make-bed --out king
