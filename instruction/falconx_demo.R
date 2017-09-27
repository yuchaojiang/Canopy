
library(CODEX)
library(falconx)
#####################################################################################
###  Below is demo dataset consisting of 39 tumor-normal paired whole-exome
###  sequencing, published in Maxwell et al. (Nature Communications, 2017).
###  https://www.nature.com/articles/s41467-017-00388-9 
###  We focus on chr17, where copy-neutral loss-of-heterozygosity has been reported.
#####################################################################################


#####################################################################################
# Below are allelic reads, genotype, and genomic locations, which can be extracted
# from vcf files.
# rda files available for download at
# https://github.com/yuchaojiang/Canopy/tree/master/instruction
#####################################################################################

chr=17 
load('mymatrix.demo.rda')
load('genotype.demo.rda')
load('reads.demo.rda')

head(mymatrix) # genomic locations and SNP info across all loci from chr17
head(genotype[,1:12]) # genotype in blood (bloodGT1 and blood GT2) and tumor (tumorGT1 and tumor GT2)
# across all samples
head(reads[,1:12]) # allelic reads in blood (AN and BN) and tumor (AT and BT) across all samples

#####################################################################################
# Apply CODEX/CODEX2 to get total coverage bias
#####################################################################################

# Get GC content from a 50bp window centered at the SNP
pos=as.numeric(mymatrix[,'POS'])
ref=IRanges(start=pos-25,end=pos+25)
gc=getgc(chr,ref)  

# total read depth
Y=matrix(nrow=nrow(reads),ncol=ncol(reads)/2)  
for(j in 1:ncol(Y)){
  Y[,j]=reads[,2*j-1]+reads[,2*j]
}

# QC procedure
pos.filter=(apply(Y,1,median)>=20)
pos=pos[pos.filter]
ref=ref[pos.filter]
gc=gc[pos.filter]
genotype=genotype[pos.filter,]
reads=reads[pos.filter,]
mymatrix=mymatrix[pos.filter,]
Y=Y[pos.filter,]

normObj=normalize2(Y,gc,K=1:3,normal_index=seq(1,77,2))
choiceofK(normObj$AIC,normObj$BIC,normObj$RSS,K=1:3,filename=paste('choiceofK.',chr,'.pdf',sep=''))
cat(paste('BIC is maximized at ',which.max(normObj$BIC),'.\n',sep=''))
Yhat=round(normObj$Yhat[[3]],0)

dim(mymatrix)  # raw vcf read.table, including genomic locations
dim(reads)   # allelic reads
dim(genotype)   # genotype
dim(Yhat)  # total coverage bias returned by CODEX



#################################################################################
# Generate input for FALCON-X: allelic read depth and genotype across all loci
#################################################################################

n=39 # total number of samples
for (i in 1:n){
  cat('Generating input for sample',i,'...\n')
  ids = (4*i-3):(4*i)
  ids2 = (2*i-1):(2*i)
  mydata = as.data.frame(cbind(mymatrix[,1:2], genotype[,ids], reads[,ids], Yhat[,ids2]))
  colnames(mydata) = c("chr", "pos", "bloodGT1", "bloodGT2", "tumorGT1",
                       "tumorGT2", "AN", "BN", "AT", "BT", 'sN','sT')
  ids=which(as.numeric(mydata[,3])!=as.numeric(mydata[,4]))
  newdata0 = mydata[ids,]
  index.na=apply(is.na(newdata0), 1, any)
  newdata=newdata0[index.na==FALSE,]
  
  # Remove loci with multiple alternative alleles
  mul.alt.filter=rep(TRUE,nrow(newdata))
  for(s in 1:nrow(newdata)){
    filter1=!is.element(as.numeric(newdata[s,'tumorGT1']),
                        c(as.numeric(newdata[s,'bloodGT1']),
                          as.numeric(newdata[s,'bloodGT2'])))
    filter2=!is.element(as.numeric(newdata[s,'tumorGT2']),
                        c(as.numeric(newdata[s,'bloodGT1']),
                          as.numeric(newdata[s,'bloodGT2'])))
    if(filter1 | filter2){
      mul.alt.filter[s]=FALSE
    }
  }
  newdata=newdata[mul.alt.filter,]
  
  # write text at germline heterozygous loci, which is used as input for Falcon-X
  write.table(newdata, file=paste("sample",i,"_het.txt",sep=""), quote=F, row.names=F)
}


#################################################################################
# Apply FALCON-X to generate allele-specific copy number profiles
#################################################################################

# CODEX normalize total read depth across samples
# falcon-x profiles ASCN in each sample separately
k=10 # calling ASCN for the 10th sample
ascn.input=read.table(paste("sample",k,"_het.txt",sep=""),head=T)
readMatrix=ascn.input[,c('AN','BN','AT','BT')]
biasMatrix=ascn.input[,c('sN','sT')]

tauhat = getChangepoints.x(readMatrix, biasMatrix, pos=ascn.input$pos)
cn = getASCN.x(readMatrix, biasMatrix, tauhat=tauhat, pos=ascn.input$pos, threshold = 0.3)
# cn$tauhat would give the indices of change-points.
# cn$ascn would give the estimated allele-specific copy numbers for each segment.
# cn$Haplotype[[i]] would give the estimated haplotype for the major chromosome in segment i
# if this segment has different copy numbers on the two homologous chromosomes.
view(cn, pos=ascn.input$pos)


if(length(tauhat)>0){
  length.thres=10^6  # Threshold for length of segments, in base pair.
  delta.cn.thres=0.3  # Threshold of absolute copy number difference between consecutive segments.
  source('falconx.qc.R') # Can be downloaded from
  # https://github.com/yuchaojiang/Canopy/tree/master/instruction 
  falcon.qc.list = falconx.qc(readMatrix = readMatrix,
                              biasMatrix = biasMatrix,
                              tauhat = tauhat,
                              cn = cn,
                              st_bp = ascn.input$pos,
                              end_bp = ascn.input$pos,
                              length.thres = length.thres,
                              delta.cn.thres = delta.cn.thres)
  
  tauhat=falcon.qc.list$tauhat
  cn=falcon.qc.list$cn
}

view(cn,pos=ascn.input$pos)


