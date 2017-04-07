########################################
########################################
#
#       Clustering toy3 example
#
########################################
########################################

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

library(Canopy)
library(scatterplot3d)
data(AML43)
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
sna_cluster=canopy.cluster$sna_cluster # cluster identity for each mutation
colc=c('green4','red3','royalblue1','darkorange1','royalblue4',
       'mediumvioletred','seagreen4','olivedrab4','steelblue4','lavenderblush4')
pchc=c(17,0,1,15,3,16,4,8,2,16)
plot((R/X)[,1],(R/X)[,2],xlab='Sample1 VAF',ylab='Sample2 VAF',col=colc[sna_cluster],pch=pchc[sna_cluster],ylim=c(0,max(R/X)),xlim=c(0,max(R/X)))

table(sna_cluster) # the 5th cluster corresponds to the noise component

R=R[sna_cluster<=4,] # exclude mutations in the noise cluster
X=X[sna_cluster<=4,]
sna_cluster=sna_cluster[sna_cluster<=4]

R.cluster=round(Mu*100)  # Generate pseudo-SNAs correponding to each cluster. 
X.cluster=pmax(R.cluster,100)   # Total depth is set at 100 here but can be obtained as median across mutations in the cluster.
rownames(R.cluster)=rownames(X.cluster)=paste('SNA.cluster',1:4,sep='')
