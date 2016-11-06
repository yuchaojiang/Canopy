# sort, dedup, and index bam files
while read line
do
echo 'Sorting sample ' $line' ...'
java -Xmx6G -jar ~/bin/SortSam.jar INPUT=/home/stat/yuchaoj/structure/andyminn/clone/$line OUTPUT=/home/stat/yuchaoj/structure/andyminn/clone/$line.sorted.bam SORT_ORDER=coordinate 
echo 'Dedupping sample ' $line' ...'
java -Xmx6G -jar ~/bin/MarkDuplicates.jar INPUT=/home/stat/yuchaoj/structure/andyminn/clone/$line.sorted.bam OUTPUT=/home/stat/yuchaoj/structure/andyminn/clone/$line.sorted.dedup.bam  METRICS_FILE=metrics.txt
echo 'Indexing sample ' $line' ...'
java -Xmx6G -jar ~/bin/BuildBamIndex.jar INPUT=/home/stat/yuchaoj/structure/andyminn/clone/$line.sorted.dedup.bam
done < bamlist1


# create realigner target
cd /home/stat/yuchaoj/structure/andyminn/clone/
while read line
do
echo 'Creating realigner target for sample ' $line' ...'
java -jar ~/bin/GenomeAnalysisTK.jar -T RealignerTargetCreator -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -I /home/stat/yuchaoj/structure/andyminn/clone/$line.sorted.dedup.bam -known /home/stat/yuchaoj/structure/hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf -known /home/stat/yuchaoj/structure/hg19/1000G_phase1.indels.hg19.sites.vcf -o $line.target_intervals.list 
done < bamlist1


# realign
while read line
do
echo 'cd /home/stat/yuchaoj/structure/andyminn/clone/; java -jar ~/bin/GenomeAnalysisTK.jar -T IndelRealigner -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -I /home/stat/yuchaoj/structure/andyminn/clone/'$line'.sorted.dedup.bam -targetIntervals '$line'.target_intervals.list -known /home/stat/yuchaoj/structure/hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf -known /home/stat/yuchaoj/structure/hg19/1000G_phase1.indels.hg19.sites.vcf -o '$line'.sorted.dedup.realigned.bam' | qsub -q bigram -N realign.$line
done < bamlist1


# recalibrate 1
while read line
do
echo 'cd /home/stat/yuchaoj/structure/andyminn/clone/; java -jar ~/bin/GenomeAnalysisTK.jar -T BaseRecalibrator -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -I '$line'.sorted.dedup.realigned.bam -knownSites /home/stat/yuchaoj/structure/hg19/dbsnp_138.hg19.vcf -knownSites /home/stat/yuchaoj/structure/hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf -knownSites /home/stat/yuchaoj/structure/hg19/1000G_phase1.indels.hg19.sites.vcf -o '$line'.recal_data.table' | qsub -q bigram -N recal1.$line
done < bamlist1


# recalibrate 2
while read line
do
echo 'cd /home/stat/yuchaoj/structure/andyminn/clone/; java -jar ~/bin/GenomeAnalysisTK.jar -T BaseRecalibrator -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -I '$line'.sorted.dedup.realigned.bam -knownSites /home/stat/yuchaoj/structure/hg19/dbsnp_138.hg19.vcf -knownSites /home/stat/yuchaoj/structure/hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf -knownSites /home/stat/yuchaoj/structure/hg19/1000G_phase1.indels.hg19.sites.vcf -BQSR '$line'.recal_data.table -o '$line'.post_recal_data.table' | qsub -q bigram -N recal2.$line
done < bamlist1


# plot recalibration_plots.pdf
while read line
do
echo 'cd /home/stat/yuchaoj/structure/andyminn/clone/; java -jar ~/bin/GenomeAnalysisTK.jar -T AnalyzeCovariates -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -before '$line'.recal_data.table -after '$line'.post_recal_data.table -plots '$line'.recalibration_plots.pdf' | qsub -N recal3.$line
done < bamlist1


# generate recalibrated bam files
while read line
do
echo 'cd /home/stat/yuchaoj/structure/andyminn/clone/; java -jar ~/bin/GenomeAnalysisTK.jar -T PrintReads -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -I '$line'.sorted.dedup.realigned.bam -BQSR '$line'.recal_data.table -o '$line'.sorted.dedup.realigned.recal.bam' | qsub -q bigram -N recalbam.$line
done < bamlist1


# gvcf calling
# HaplotypeCaller (for germline point mutation calling)
while read line
do
echo 'cd /home/stat/yuchaoj/structure/andyminn/clone/; java -jar ~/bin/GenomeAnalysisTK.jar -T HaplotypeCaller -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -I '$line' --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 --dbsnp /home/stat/yuchaoj/structure/hg19/dbsnp_138.hg19.vcf -L '$line'.target_intervals.list -o '$line'.raw_variants.g.vcf' | qsub -q bigram -N gvcf.$line
done < vcfbam
# UnifiedGenotyper (for somatic point mutation calling)
line=vcfbam.list
echo 'cd /home/stat/yuchaoj/structure/andyminn/clone/; java -jar ~/bin/GenomeAnalysisTK.jar -T UnifiedGenotyper -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -I '$line' --dbsnp /home/stat/yuchaoj/structure/hg19/dbsnp_138.hg19.vcf -o '$line'.output.vcf' | qsub -q bigram -N $line


# joint genotyping across samples
echo 'cd /home/stat/yuchaoj/structure/andyminn/clone/; java -jar ~/bin/GenomeAnalysisTK.jar -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -T GenotypeGVCFs -V gvcfs.list -o output.vcf' | qsub -q bigram -N genotypeGVCF


## below might not be needed 

# variant recalibration
java -jar ~/bin/GenomeAnalysisTK.jar -T VariantRecalibrator -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -input output.vcf -resource:hapmap,known=false,training=true,truth=true,prior=15.0 /home/stat/yuchaoj/structure/hg19/hapmap_3.3.hg19.vcf -resource:omni,known=false,training=true,truth=true,prior=12.0 /home/stat/yuchaoj/structure/hg19/1000G_omni2.5.hg19.vcf -resource:1000G,known=false,training=true,truth=false,prior=10.0 /home/stat/yuchaoj/structure/hg19/1000G_phase1.snps.high_confidence.hg19.vcf -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 /home/stat/yuchaoj/structure/hg19/dbsnp_138.hg19.vcf -an DP -an QD -an FS -an SOR -an MQ -an MQRankSum -an ReadPosRankSum -an InbreedingCoeff -mode SNP -tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 90.0 -recalFile recalibrate_SNP.recal -tranchesFile recalibrate_SNP.tranches -rscriptFile recalibrate_SNP_plots.R 
java -jar ~/bin/GenomeAnalysisTK.jar -T ApplyRecalibration -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -input output.vcf -mode SNP --ts_filter_level 99.0 -recalFile recalibrate_SNP.recal -tranchesFile recalibrate_SNP.tranches -o recalibrated_snps_raw_indels.vcf
java -jar ~/bin/GenomeAnalysisTK.jar -T VariantRecalibrator -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -input recalibrated_snps_raw_indels.vcf -resource:mills,known=true,training=true,truth=true,prior=12.0 /home/stat/yuchaoj/structure/hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf -an QD -an DP -an FS -an SOR -an MQRankSum -an ReadPosRankSum -an InbreedingCoeff -mode INDEL -tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 90.0 --maxGaussians 4 -recalFile recalibrate_INDEL.recal -tranchesFile recalibrate_INDEL.tranches -rscriptFile recalibrate_INDEL_plots.R 
java -jar ~/bin/GenomeAnalysisTK.jar -T ApplyRecalibration -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -input recalibrated_snps_raw_indels.vcf -mode INDEL --ts_filter_level 99.0 -recalFile recalibrate_INDEL.recal -tranchesFile recalibrate_INDEL.tranches -o recalibrated_variants.vcf 


# variant filtration
#java -jar ~/bin/GenomeAnalysisTK.jar -T SelectVariants -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -V recalibrated_variants.vcf -selectType SNP -o selected_snps.vcf 
#java -jar ~/bin/GenomeAnalysisTK.jar -T SelectVariants -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -V recalibrated_variants.vcf -selectType INDEL -o selected_indels.vcf 
#java -jar ~/bin/GenomeAnalysisTK.jar -T VariantFiltration -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -V selected_snps.vcf --filterExpression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filterName "my_snp_filter" -o filtered_snps.vcf 
#java -jar ~/bin/GenomeAnalysisTK.jar -T VariantFiltration -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -V selected_indels.vcf --filterExpression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" --filterName "my_indel_filter" -o filtered_indels.vcf 
