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


# HaplotypeCaller (for germline point mutation calling)
while read line
do
echo 'cd /home/stat/yuchaoj/structure/andyminn/clone/; java -jar ~/bin/GenomeAnalysisTK.jar -T HaplotypeCaller -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -I '$line' --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 --dbsnp /home/stat/yuchaoj/structure/hg19/dbsnp_138.hg19.vcf -L '$line'.target_intervals.list -o '$line'.raw_variants.g.vcf' | qsub -q bigram -N gvcf.$line
done < vcfbam
# gvcf calling: joint genotyping across samples
echo 'cd /home/stat/yuchaoj/structure/andyminn/clone/; java -jar ~/bin/GenomeAnalysisTK.jar -R /home/stat/yuchaoj/structure/hg19/ucsc.hg19.fasta -T GenotypeGVCFs -V gvcfs.list -o output.vcf' | qsub -q bigram -N genotypeGVCF


# UnifiedGenotyper (for somatic point mutation calling)
sbatch -t 1-23:00 --mem 50000 --wrap="java -Xmx40G -jar ~/yuchaojlab/bin/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ~/yuchaojlab/lib/ucsc.hg19.fasta -I vcfbam.list -o unifiedgenotyper.output.vcf" --job-name unifedgenotyper
