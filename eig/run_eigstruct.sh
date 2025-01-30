
####################################### EIGEN ANALYSIS #######################################
# Convert File Formats
#if [[ $# != 0 ]]; then
   echo """
	NB: Please edit this script if you wish to run on a different data set
	    This is meant to be an easy run of the entire PCA outlier removal pipeline
   """
   sleep 3
#else
   invcf=$1
   cd CONVERTF/
   ./convertf_all.sh all ../../qc/passbicore_phased.vcf.gz 0.05 passbicore 

   # Compute Eigenvectors
   cd ../EIGENSTRAT/
   ./run_eigenstrat.perl passbicore 5 5 5 6.0
   ./plotPCA.sh passbicore
  
   # Extract samples that passed PCA outlier removal
   cd ../../qc/
   ./get_pca_filtered.sh passbicore_phased.vcf.gz

   cd ../eig/CONVERTF/
   ./convertf_all.sh all ../../qc/passbicore_phased_pca-filtered.vcf.gz 0.05 pcapassbicore

   # Compute Eigenvectors for PCA-filtered samples without further pruning
   cd ../EIGENSTRAT/
   ./run_eigenstrat.perl pcapassbicore 5 0 5 6.0
   ./plotPCA.sh pcapassbicore
   
   # Extract samples for each category excluding those with no label
   file=var_colnum.txt   
   while read -r line; do 
	   ./getnonmis.sh $line; 
   done < $file

   cd ../CONVERTF/ 
   for i in DSEX Status PARACAT DAGECAT ALTCAT; do 
	   ./convertf_all.sh sub ../../qc/passbicore_phased_pca-filtered.vcf.gz 0.05 nonmis${i} ../EIGENSTRAT/nonmis${i}.ids; 
   done
  
   # Run smartpca and extract top fst snps for each category
   cd ../POPGEN/
   for i in nonmisALTCAT nonmisDSEX nonmisDAGECAT nonmisPARACAT nonmisStatus; do 
	   ./run_popgenstats.sh ${i} 10; 
   done

   # Extract only those best FST SNPs and run PCA for each category
   cd ../CONVERTF/
   file=extr_params.txt
   while read -r line; do 
	   ./extract_fst_snps.sh $line; 
   done < $file

   # Run PCA each category and produce a single plot
   cd ../EIGENSTRAT/
   for i in altbest dsexbest statbest parabest agebest; do
           ./run_eigenstrat.perl ${i} 5 0 5 6.0 
   done

   ./plotBestFst.sh

   #--------------------------------------------------------------------
   #cd ../../fst/
   #./run_all.sh
   #
   #cd -

   ##----Pull Fst-best SNPs
   #for i in age alt dsex para stat; do 
   #        ./extract_fst_snps.sh passbicore ../../fst/${i}best_fst.txt
   #done

## Compute Population Genetic Statistics
#cd POPGEN/
#./run_popgenstats.sh
#
#cd ../
#fi
