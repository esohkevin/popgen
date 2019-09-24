
####################################### EIGEN ANALYSIS #######################################
# Convert File Formats
cd CONVERTF/
./convertf_all.sh all ../../qc/bipcore.vcf.gz 0.2 passbicore

cd ../../fst/
./run_all.sh

cd -

#----Pull Fst-best SNPs
for i in age alt dsex para stat; do 
        ./extract_fst_snps.sh passbicore ../../fst/${i}best_fst.txt
done


cd ../

# Compute Eigenvectors
cd EIGENSTRAT/
./run_eigenstrat.perl passbicore 5 5 5 6.0

#----Compute eigenvalues with Fst-best SNPs
for i in altbest dsexbest statbest parabest agebest; do
       	./run_eigenstrat.perl ${i} 5 5 5 6.0 
done

./plotPCA.sh passbicore

cd ../

## Compute Population Genetic Statistics
#cd POPGEN/
#./run_popgenstats.sh
#
#cd ../


