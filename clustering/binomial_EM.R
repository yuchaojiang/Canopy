
########################################
########################################
#
#        Generating data input
#
########################################
########################################

setwd("C:/Users/yuchaoj/Dropbox/GitHub/canopy_binomial_clustering")

load('realtree_200_500_3_4_1.rda')
dim(R); dim(X) # 200 mutations across 3 samples
sim_toy=list(R=R,X=X)
save(sim_toy,file='sim_toy.rda')

# AML43
aml43=read.table('869586_DingEtAl.txt',head=T,sep='\t')
colnames(aml43)

# make sure all CNs are 2
aml43=aml43[aml43$NormalCN==2 & aml43$TumorCN==2 & aml43$RelapseCN==2,]

Y1=as.numeric(as.character(aml43$TumorVarReads))
N1=as.numeric(as.character(aml43$TumorRefReads))+as.numeric(as.character(aml43$TumorVarReads))
Y2=as.numeric(as.character(aml43$RelapseVarReads))
N2=as.numeric(as.character(aml43$RelapseRefReads))+as.numeric(as.character(aml43$RelapseVarReads))


filter=(Y1/N1<0.6)&(Y2/N2<0.6)

Y1=Y1[filter]
Y2=Y2[filter]
N1=N1[filter]
N2=N2[filter]

R=cbind(Y1,Y2)
X=cbind(N1,N2)

colnames(R)=colnames(X)=c('Primary','Relapse')
rownames(R)=rownames(X)=paste('mut',1:nrow(R),sep ='')

AML43=list(R=R,X=X)
save(AML43,file='AML43.rda')




########################################
########################################
#
#       Clustering toy example
#
########################################
########################################

setwd("C:/Users/yuchaoj/Dropbox/GitHub/canopy_binomial_clustering")
library(Canopy)
library(pheatmap)
library(scatterplot3d)
source('canopy.cluster.Estep.R')
source('canopy.cluster.Mstep.R')
source('canopy.cluster.R')
load('sim_toy.rda')
R=sim_toy$R; X=sim_toy$X
dim(R);dim(X)
num_cluster=2:9 # Range of number of clusters to run
num_run=20 # How many EM runs per clustering step for each mutation cluster wave

canopy.cluster=canopy.cluster(R = R,
                              X = X,
                              num_cluster = num_cluster,
                              num_run = num_run)

# BIC to determine the optimal number of mutation clusters
bic_output=canopy.cluster$bic_output
#pdf(file='sim_toy_BIC.pdf',width=4,height=4)
plot(num_cluster,bic_output,xlab='Number of mutation clsuters',ylab='BIC',type='b',main='BIC for model selection')
abline(v=num_cluster[which.max(bic_output)],lty=2)
#dev.off()


# Visualization of clustering result
Mu=canopy.cluster$Mu # VAF centroid for each cluster
Tau=canopy.cluster$Tau  # Prior for mutation cluster, with a K+1 component
mut_cluster=canopy.cluster$mut_cluster # cluster identity for each mutation
#pdf(file='sim_toy_classification.pdf',width=8,height=4)
par(mfrow=c(1,2))
colc=c('green4','red3','royalblue1','darkorange1','royalblue4',
       'mediumvioletred','seagreen4','olivedrab4','steelblue4','lavenderblush4')
pchc=c(17,0,1,15,3,16,4,8,2,16)
plot((R/X)[,1],(R/X)[,2],xlab='Sample1 VAF',ylab='Sample2 VAF',col=colc[mut_cluster],pch=pchc[mut_cluster],ylim=c(0,max(R/X)),xlim=c(0,max(R/X)))
scatterplot3d((R/X)[,1],(R/X)[,2],(R/X)[,3],xlim=c(0,max(R/X)),ylim=c(0,max(R/X)),zlim=c(0,max(R/X)),color=colc[mut_cluster],pch=pchc[mut_cluster],
              xlab='Sample1 VAF',ylab='Sample2 VAF',zlab='Sample3 VAF')
par(mfrow=c(1,1))
#dev.off()


########################################
########################################
#
#       Clustering AML43
#
########################################
########################################


setwd("C:/Users/yuchaoj/Dropbox/GitHub/canopy_binomial_clustering")
library(Canopy)
library(pheatmap)
library(scatterplot3d)
source('canopy.cluster.Estep.R')
source('canopy.cluster.Mstep.R')
source('canopy.cluster.R')
load('AML43.rda')
R=AML43$R; X=AML43$X
dim(R);dim(X)
num_cluster=4 # Range of number of clusters to run
num_run=10 # How many EM runs per clustering step for each mutation cluster wave
Tau_Kplus1=0.05
Mu.init=cbind(c(0.01,0.15,0.25,0.45),c(0.2,0.2,0.01,0.2))

canopy.cluster=canopy.cluster(R = R,
                              X = X,
                              num_cluster = num_cluster,
                              num_run = num_run,
                              Mu.init = Mu.init,
                              Tau_Kplus1=Tau_Kplus1)


# Visualization of clustering result
Mu=canopy.cluster$Mu # VAF centroid for each cluster
Tau=canopy.cluster$Tau  # Prior for mutation cluster, with a K+1 component
mut_cluster=canopy.cluster$mut_cluster # cluster identity for each mutation
#pdf(file='AML43_classification.pdf',width=4,height=4)
colc=c('green4','red3','royalblue1','darkorange1','royalblue4',
       'mediumvioletred','seagreen4','olivedrab4','steelblue4','lavenderblush4')
pchc=c(17,0,1,15,3,16,4,8,2,16)
plot((R/X)[,1],(R/X)[,2],xlab='Sample1 VAF',ylab='Sample2 VAF',col=colc[mut_cluster],pch=pchc[mut_cluster],ylim=c(0,max(R/X)),xlim=c(0,max(R/X)))
#dev.off()









