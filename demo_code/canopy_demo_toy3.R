#######################################################
#######################################################
#######                                         #######
#######               SNA clustering            #######
#######                                         #######
#######################################################
#######################################################
library(Canopy)
data(toy3)
R=toy3$R; X=toy3$X
dim(R);dim(X)
num_cluster=2:9 # Range of number of clusters to run
num_run=10 # How many EM runs per clustering step for each mutation cluster wave
canopy.cluster=canopy.cluster(R = R,
                              X = X,
                              num_cluster = num_cluster,
                              num_run = num_run)

# BIC to determine the optimal number of mutation clusters
bic_output=canopy.cluster$bic_output
plot(num_cluster,bic_output,xlab='Number of mutation clsuters',ylab='BIC',type='b',main='BIC for model selection')
abline(v=num_cluster[which.max(bic_output)],lty=2)
# Visualization of clustering result
Mu=canopy.cluster$Mu # VAF centroid for each cluster
Tau=canopy.cluster$Tau  # Prior for mutation cluster, with a K+1 component
sna_cluster=canopy.cluster$sna_cluster # cluster identity for each mutation
colc=c('green4','red3','royalblue1','darkorange1','royalblue4',
       'mediumvioletred','seagreen4','olivedrab4','steelblue4','lavenderblush4')
pchc=c(17,0,1,15,3,16,4,8,2,16)
plot((R/X)[,1],(R/X)[,2],xlab='Sample1 VAF',ylab='Sample2 VAF',col=colc[sna_cluster],pch=pchc[sna_cluster],ylim=c(0,max(R/X)),xlim=c(0,max(R/X)))
library(scatterplot3d)
scatterplot3d((R/X)[,1],(R/X)[,2],(R/X)[,3],xlim=c(0,max(R/X)),ylim=c(0,max(R/X)),zlim=c(0,max(R/X)),color=colc[sna_cluster],pch=pchc[sna_cluster],
              xlab='Sample1 VAF',ylab='Sample2 VAF',zlab='Sample3 VAF')


#######################################################
#######################################################
#######                                         #######
#######               MCMC sampling             #######
#######                                         #######
#######################################################
#######################################################
projectname='toy3'
K = 3:5 # number of subclones
numchain = 15 # number of chains with random initiations
sampchain = canopy.sample.cluster.nocna(R = R, X = X, sna_cluster = sna_cluster,
                                        K = K, numchain = numchain, 
                                        max.simrun = 100000, min.simrun = 20000,
                                        writeskip = 200, projectname = projectname,
                                        cell.line = FALSE, plot.likelihood = TRUE)
save.image(file = paste(projectname, '_postmcmc_image.rda',sep=''),
           compress = 'xz')


#######################################################
#######################################################
#######                                         #######
#######   BIC to determine number of subclones  #######
#######                                         #######
#######################################################
#######################################################
library(Canopy)
projectname='toy3'
load(paste(projectname, '_postmcmc_image.rda', sep=''))
burnin = 50
thin = 10
# If pdf = TRUE, a pdf will be generated.
bic = canopy.BIC(sampchain = sampchain, projectname = projectname, K = K,
                 numchain = numchain, burnin = burnin, thin = thin, pdf = TRUE)
optK = K[which.max(bic)]


#######################################################
#######################################################
#######                                         #######
#######         posterior tree evaluation       #######
#######                                         #######
#######################################################
#######################################################
post = canopy.post(sampchain = sampchain, projectname = projectname, K = K,
                   numchain = numchain, burnin = burnin, thin = thin, 
                   optK = optK, C=NULL, post.config.cutoff = 0.05)
samptreethin = post[[1]]   # list of all post-burnin and thinning trees
samptreethin.lik = post[[2]]   # likelihoods of trees in samptree
config = post[[3]]
config.summary = post[[4]]
print(config.summary)
# first column: tree configuration
# second column: posterior configuration probability in the entire tree space
# third column: posterior configuration likelihood in the subtree space
# note: if modes of posterior probabilities aren't obvious, run sampling longer.


#######################################################
#######################################################
#######                                         #######
#######          Tree output and plot           #######
#######                                         #######
#######################################################
#######################################################
# choose the configuration with the highest posterior likelihood
config.i = config.summary[which.max(config.summary[,3]),1]
cat('Configuration', config.i, 'has the highest posterior likelihood.\n')
output.tree = canopy.output(post, config.i, C=NULL)
pdf.name = paste(projectname, '_config_highest_likelihood.pdf', sep='')
canopy.plottree(output.tree, pdf = TRUE, pdf.name = pdf.name, txt = TRUE, txt.name = 'toy3_mut.txt')
output.tree$P
toy3$realP
output.tree$Z[,c(1,2,4,3)]==toy3$realZ  # note that the clone order can be different.

