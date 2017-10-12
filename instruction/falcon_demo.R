
library(falcon)

# This is a demo dataset from relapse genome of neuroblastoma with matched normal
# from Eleveld et al. (Nature Genetics 2015).

# Falcon takes as input germline heterozygous variants, which can be called by 
# GATK or VarScan2.

# The rda file can be downloaded at:
# https://www.dropbox.com/s/i4k6xxp5c0ajk6e/preprocessed.rda?dl=0
load('preprocessed.rda')

# calculate depth ratio (total read counts of tumor versus normal)
rdep.relapse=sum(relapse$Tumor_ReadCount_Total)/sum(relapse$Normal_ReadCount_Total)
rdep.primary=sum(primary$Tumor_ReadCount_Total)/sum(primary$Normal_ReadCount_Total)

# Falcon processes each chromosome separately and here we only show demonstration
# on a few chromosomes, for example, chr 14 where a copy-neutral loss of heterozygosity 
# has been previously reported.

for(chr in c(4,7,11,14,17,20)){
  cat(chr)
  load('preprocessed.rda')
  library(falcon)
  primary.chr=primary[which(primary[,'Chromosome']==chr),]
  relapse.chr=relapse[which(relapse[,'Chromosome']==chr),]
  rm(primary);rm(relapse)
  
  
  ###########################################
  ###########################################
  #
  #        Relapse genome
  #
  ###########################################
  ###########################################  
  
  
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
  
  # total number of reads greater than 30 in both tumor and normal
  depth.filter1=(relapse.chr[,"Normal_ReadCount_Ref"]+relapse.chr[,"Normal_ReadCount_Alt"])>=30
  depth.filter2=(relapse.chr[,"Tumor_ReadCount_Ref"]+relapse.chr[,"Tumor_ReadCount_Alt"])>=30
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
  cn.relapse = getASCN(readMatrix.relapse, tauhat=tauhat.relapse, rdep = rdep.relapse, threshold = 0.3)
  
  # Chromosomal view of segmentation results.
  pdf(file=paste('falcon.relapse.',chr,'.pdf',sep=''),width=5,height=8)
  view(cn.relapse,pos=relapse.chr[,'Start_position'], rdep = rdep.relapse)
  dev.off()
  
  # save image file.
  save.image(file=paste('falcon_relapse_',chr,'.rda',sep=''))
  
  
  ########################################
  # Further curate FALCON's segmentation.
  ########################################
  
  # From the pdf above, we see that:
  # (1) There are small segments that need to be removed;
  # (2) Consecutive segments with similar allelic cooy number states need to be combined.
  if(length(tauhat.relapse)>0){
    length.thres=10^6  # Threshold for length of segments, in base pair.
    delta.cn.thres=0.3  # Threshold of absolute copy number difference between consecutive segments.
    source('falcon_demo/falcon.qc.R') # Can be downloaded from
    # https://github.com/yuchaojiang/Canopy/blob/master/instruction/falcon.qc.R
    falcon.qc.list = falcon.qc(readMatrix = readMatrix.relapse,
                               tauhat = tauhat.relapse,
                               cn = cn.relapse,
                               st_bp = relapse.chr[,"Start_position"],
                               end_bp = relapse.chr[,"End_position"],
                               rdep = rdep.relapse,
                               length.thres = length.thres,
                               delta.cn.thres = delta.cn.thres)
    
    tauhat.relapse=falcon.qc.list$tauhat
    cn.relapse=falcon.qc.list$cn
  }
  
  # Chromosomal view of QC'ed segmentation results.
  pdf(file=paste('falcon.relapse.qc.',chr,'.pdf',sep=''),width=5,height=8)
  view(cn.relapse,pos=relapse.chr[,'Start_position'], rdep = rdep.relapse)
  dev.off()
  
  
  #################################################
  # Generate Canopy's input with s.d. measurement.
  #################################################
  
  # This is to generate table output including genomic locations for 
  # segment boudaries.
  # For Canopy's input, we use Bootstrap-based method to estimate the
  # standard deviations for the allele-specific copy numbers.
  
  source('falcon_demo/falcon.output.R') # Can be downloaded from
  # https://github.com/yuchaojiang/Canopy/blob/master/instruction/falcon.output.R
  falcon.output=falcon.output(readMatrix = readMatrix.relapse,
                              tauhat = tauhat.relapse,
                              cn = cn.relapse,
                              st_bp = relapse.chr[,"Start_position"],
                              end_bp = relapse.chr[,"End_position"],
                              nboot = 5000)
  falcon.output = cbind(chr=rep(chr,nrow(falcon.output)), falcon.output)
  write.table(falcon.output, file=paste('faclon.relapse.output.',chr,'.txt',sep=''), col.names =T, row.names = F, sep='\t', quote = F)
  

  
  ###########################################
  ###########################################
  #
  #        Primary tumor
  #
  ###########################################
  ###########################################  
  
  
  ###########################################
  # Focus on germline heterozygous variants.
  ###########################################
  
  # remove variants with missing genotype
  primary.chr=primary.chr[primary.chr[,'Match_Norm_Seq_Allele1']!=' ',]
  primary.chr=primary.chr[primary.chr[,'Match_Norm_Seq_Allele2']!=' ',]
  primary.chr=primary.chr[primary.chr[,'Reference_Allele']!=' ',]
  primary.chr=primary.chr[primary.chr[,'TumorSeq_Allele1']!=' ',]
  primary.chr=primary.chr[primary.chr[,'TumorSeq_Allele2']!=' ',]
  
  # get germline heterozygous loci (normal allele1 != normal allele2)
  primary.chr=primary.chr[(as.matrix(primary.chr[,'Match_Norm_Seq_Allele1'])!=as.matrix(primary.chr[,'Match_Norm_Seq_Allele2'])),]
  
  
  ############################################################
  # QC procedures to remove false neg and false pos variants.
  # The thresholds can be adjusted.
  ############################################################
  
  # remove indels (this can be relaxed but we think indels are harder to call than SNPs)
  indel.filter1=nchar(as.matrix(primary.chr[,'Reference_Allele']))<=1
  indel.filter2=nchar(as.matrix(primary.chr[,'Match_Norm_Seq_Allele1']))<=1
  indel.filter3=nchar(as.matrix(primary.chr[,'Match_Norm_Seq_Allele2']))<=1
  indel.filter4=nchar(as.matrix(primary.chr[,'TumorSeq_Allele1']))<=1
  indel.filter5=nchar(as.matrix(primary.chr[,'TumorSeq_Allele2']))<=1
  primary.chr=primary.chr[indel.filter1 & indel.filter2 & indel.filter3 & indel.filter4 & indel.filter5,]
  
  # total number of reads greater than 30 in both tumor and normal
  depth.filter1=(primary.chr[,"Normal_ReadCount_Ref"]+primary.chr[,"Normal_ReadCount_Alt"])>=30
  depth.filter2=(primary.chr[,"Tumor_ReadCount_Ref"]+primary.chr[,"Tumor_ReadCount_Alt"])>=30
  primary.chr=primary.chr[depth.filter1 & depth.filter2,]
  
  
  #########################
  # Generate FALCON input.
  #########################
  
  # Data frame with four columns: tumor ref, tumor alt, normal ref, normal alt.
  readMatrix.primary=as.data.frame(primary.chr[,c('Tumor_ReadCount_Ref',
                                                  'Tumor_ReadCount_Alt',
                                                  'Normal_ReadCount_Ref',
                                                  'Normal_ReadCount_Alt')])
  colnames(readMatrix.primary)=c('AT','BT','AN','BN')
  dim(readMatrix.primary); dim(primary.chr)
  
  
  ###############################
  # Run FALCON and view results.
  ###############################
  
  tauhat.primary=getChangepoints(readMatrix.primary)
  cn.primary = getASCN(readMatrix.primary, tauhat=tauhat.primary, rdep = rdep.primary, threshold = 0.3)
  
  # Chromosomal view of segmentation results.
  pdf(file=paste('falcon.primary.',chr,'.pdf',sep=''),width=5,height=8)
  view(cn.primary,pos=primary.chr[,'Start_position'], rdep = rdep.primary)
  dev.off()
  
  # save image file.
  save.image(file=paste('falcon_primary_',chr,'.rda',sep=''))
  
  
  ########################################
  # Further curate FALCON's segmentation.
  ########################################
  
  # From the pdf above, we see that:
  # (1) There are small segments that need to be removed;
  # (2) Consecutive segments with similar allelic cooy number states need to be combined.
  if(length(tauhat.primary)>0){
    length.thres=10^6  # Threshold for length of segments, in base pair.
    delta.cn.thres=0.3  # Threshold of absolute copy number difference between consecutive segments.
    source('falcon_demo/falcon.qc.R') # Can be downloaded from
    # https://github.com/yuchaojiang/Canopy/blob/master/instruction/falcon.qc.R
    falcon.qc.list = falcon.qc(readMatrix = readMatrix.primary,
                               tauhat = tauhat.primary,
                               cn = cn.primary,
                               st_bp = primary.chr[,"Start_position"],
                               end_bp = primary.chr[,"End_position"],
                               rdep = rdep.primary,
                               length.thres = length.thres,
                               delta.cn.thres = delta.cn.thres)
    
    tauhat.primary=falcon.qc.list$tauhat
    cn.primary=falcon.qc.list$cn
  }
 
  # Chromosomal view of QC'ed segmentation results.
  pdf(file=paste('falcon.primary.qc.',chr,'.pdf',sep=''),width=5,height=8)
  view(cn.primary,pos=primary.chr[,'Start_position'], rdep = rdep.primary)
  dev.off()
  
  
  #################################################
  # Generate Canopy's input with s.d. measurement.
  #################################################
  
  # This is to generate table output including genomic locations for 
  # segment boudaries.
  # For Canopy's input, we use Bootstrap-based method to estimate the
  # standard deviations for the allele-specific copy numbers.
  
  source('falcon_demo/falcon.output.R') # Can be downloaded from
  # https://github.com/yuchaojiang/Canopy/blob/master/instruction/falcon.output.R
  falcon.output=falcon.output(readMatrix = readMatrix.primary,
                              tauhat = tauhat.primary,
                              cn = cn.primary,
                              st_bp = primary.chr[,"Start_position"],
                              end_bp = primary.chr[,"End_position"],
                              nboot = 5000)
  falcon.output = cbind(chr=rep(chr,nrow(falcon.output)), falcon.output)
  write.table(falcon.output, file=paste('faclon.primary.output.',chr,'.txt',sep=''), col.names =T, row.names = F, sep='\t', quote = F)  
}




# Above we automated the QC procedure after FALCON's initial call.
# However, sometimes further manual correction / curation is needed.
# Visual eyecheck is thus strongly recommended.
# Below is a manual correction for chr7.

chr=7
load("falcon_primary_7.rda")

tauhat.primary

if(length(tauhat.primary)>0){
  length.thres=10^6  # Threshold for length of segments, in base pair.
  delta.cn.thres=0.3  # Threshold of absolute copy number difference between consecutive segments.
  source('falcon_demo/falcon.qc.R') # Can be downloaded from
  # https://github.com/yuchaojiang/Canopy/blob/master/instruction/falcon.qc.R
  falcon.qc.list = falcon.qc(readMatrix = readMatrix.primary,
                             tauhat = tauhat.primary,
                             cn = cn.primary,
                             st_bp = primary.chr[,"Start_position"],
                             end_bp = primary.chr[,"End_position"],
                             rdep = rdep.primary,
                             length.thres = length.thres,
                             delta.cn.thres = delta.cn.thres)
  
  tauhat.primary=falcon.qc.list$tauhat
  cn.primary=falcon.qc.list$cn
}

tauhat.primary
tauhat.primary=c(tauhat.primary,37821)
cn.primary = getASCN(readMatrix.primary, tauhat=tauhat.primary, rdep = rdep.primary, threshold = 0.3)


# Chromosomal view of QC'ed segmentation results.
pdf(file=paste('falcon.primary.qc.',chr,'.pdf',sep=''),width=5,height=8)
view(cn.primary,pos=primary.chr[,'Start_position'], rdep = rdep.primary)
dev.off()

source('falcon_demo/falcon.output.R') # Can be downloaded from
# https://github.com/yuchaojiang/Canopy/blob/master/instruction/falcon.output.R
falcon.output=falcon.output(readMatrix = readMatrix.primary,
                            tauhat = tauhat.primary,
                            cn = cn.primary,
                            st_bp = primary.chr[,"Start_position"],
                            end_bp = primary.chr[,"End_position"],
                            nboot = 5000)
falcon.output = cbind(chr=rep(chr,nrow(falcon.output)), falcon.output)
write.table(falcon.output, file=paste('faclon.primary.output.',chr,'.txt',sep=''), col.names =T, row.names = F, sep='\t', quote = F)

