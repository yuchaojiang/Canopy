setwd("~/Dropbox/bioinfo_pipeline/pipeline_neuroblastoma_primary_relapse/falcon_demo")

library(falcon)

# This is a demo dataset from relapse genome of neuroblastoma with matched normal
# from Eleveld et al. (Nature Genetics 2015).

# Falcon processes each chromosome separately and here we only show demonstration
# of chr14, where a copy-neutral LOH event occurs.

# Falcon takes as input germline heterozygous variants, which can be called by 
# GATK or VarScan2.

# The rda file can be downloaded at:
# https://github.com/yuchaojiang/Canopy/blob/master/instruction/relapse.chr.rda

load('relapse.chr.rda')
head(relapse.chr)

###########################################
# Focus on germline heterozygous variants.
###########################################

# remove variants with missing genotype
relapse.chr=relapse.chr[relapse.chr[,'Match_Norm_Seq_Allele1']!=' ',]
relapse.chr=relapse.chr[relapse.chr[,'Match_Norm_Seq_Allele2']!=' ',]
relapse.chr=relapse.chr[relapse.chr[,'Reference_Allele']!=' ',]
relapse.chr=relapse.chr[relapse.chr[,'TumorSeq_Allele1']!=' ',]
relapse.chr=relapse.chr[relapse.chr[,'TumorSeq_Allele2']!=' ',]

# get germline heterozygous loci (normal allele1 != normal allele2)
relapse.chr=relapse.chr[(as.matrix(relapse.chr[,'Match_Norm_Seq_Allele1'])!=as.matrix(relapse.chr[,'Match_Norm_Seq_Allele2'])),]


############################################################
# QC procedures to remove false neg and false pos variants.
# The thresholds can be adjusted.
############################################################

# remove indels (this can be relaxed but we think indels are harder to call than SNPs)
indel.filter1=nchar(as.matrix(relapse.chr[,'Reference_Allele']))<=1
indel.filter2=nchar(as.matrix(relapse.chr[,'Match_Norm_Seq_Allele1']))<=1
indel.filter3=nchar(as.matrix(relapse.chr[,'Match_Norm_Seq_Allele2']))<=1
indel.filter4=nchar(as.matrix(relapse.chr[,'TumorSeq_Allele1']))<=1
indel.filter5=nchar(as.matrix(relapse.chr[,'TumorSeq_Allele2']))<=1
relapse.chr=relapse.chr[indel.filter1 & indel.filter2 & indel.filter3 & indel.filter4 & indel.filter5,]

# total number of reads greater than 20 in both tumor and normal
depth.filter1=(relapse.chr[,"Normal_ReadCount_Ref"]+relapse.chr[,"Normal_ReadCount_Alt"])>=20
depth.filter2=(relapse.chr[,"Tumor_ReadCount_Ref"]+relapse.chr[,"Tumor_ReadCount_Alt"])>=20
relapse.chr=relapse.chr[depth.filter1 & depth.filter2,]


#########################
# Generate FALCON input.
#########################

# Data frame with four columns: tumor ref, tumor alt, normal ref, normal alt.
readMatrix.relapse=as.data.frame(relapse.chr[,c('Tumor_ReadCount_Ref',
                                                'Tumor_ReadCount_Alt',
                                                'Normal_ReadCount_Ref',
                                                'Normal_ReadCount_Alt')])
colnames(readMatrix.relapse)=c('AT','BT','AN','BN')
dim(readMatrix.relapse); dim(relapse.chr)


###############################
# Run FALCON and view results.
###############################

tauhat.relapse=getChangepoints(readMatrix.relapse)
cn.relapse = getASCN(readMatrix.relapse, tauhat=tauhat.relapse)

# Chromosomal view of segmentation results.
pdf(file='falcon.relapse.pdf',width=5,height=8)
view(cn.relapse)
dev.off()

# save image file.
save.image(file=paste('falcon_relapse.rda',sep=''))


########################################
# Further curate FALCON's segmentation.
########################################

# From the pdf above, we see that:
# (1) There are small segments that need to be removed;
# (2) Consecutive segments with similar allelic cooy number states need to be combined.

length.thres=10^6  # Threshold for length of segments, in base pair.
delta.cn.thres=0.3  # Threshold of absolute copy number difference between consecutive segments.
source('falcon.qc.R') # Can be downloaded from
# https://github.com/yuchaojiang/Canopy/blob/master/instruction/falcon.qc.R
falcon.qc.list = falcon.qc(readMatrix = readMatrix.relapse,
                           tauhat = tauhat.relapse,
                           cn = cn.relapse,
                           st_bp = relapse.chr[,"Start_position"],
                           end_bp = relapse.chr[,"End_position"],
                           length.thres = length.thres,
                           delta.cn.thres = delta.cn.thres)

tauhat.relapse=falcon.qc.list$tauhat
cn.relapse=falcon.qc.list$cn

# Chromosomal view of QC'ed segmentation results.
pdf(file='falcon.relapse.qc.pdf',width=5,height=8)
view(cn.relapse)
dev.off()


#################################################
# Generate Canopy's input with s.d. measurement.
#################################################

# This is to generate table output including genomic locations for 
# segment boudaries.
# For Canopy's input, we use Bootstrap-based method to estimate the
# standard deviations for the allele-specific copy numbers.

source('falcon.output.R') # Can be downloaded from
# https://github.com/yuchaojiang/Canopy/blob/master/instruction/falcon.output.R
falcon.output=falcon.output(readMatrix = readMatrix.relapse,
                            tauhat = tauhat.relapse,
                            cn = cn.relapse,
                            st_bp = relapse.chr[,"Start_position"],
                            end_bp = relapse.chr[,"End_position"],
                            nboot = 10000)
chr=14
falcon.output = cbind(rep(chr,nrow(falcon.output)), falcon.output)
write.table(falcon.output, file='faclon.output.txt', col.names =T, row.names = F, sep='\t', quote = F)


