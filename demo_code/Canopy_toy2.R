

# install.packages('Canopy_1.1.1.tar.gz', repos = NULL, type="source")

# echo 'cd /home/stat/yuchaoj/canopy_test; R --no-save < Canopy_shuffle.R' | qsub -q bigram -N Canopy_shuffle
# echo 'cd /home/stat/yuchaoj/canopy_test; R --no-save < Canopy_demo.R' | qsub -q bigram -N Canopy_demo
# echo 'cd /home/stat/yuchaoj/canopy_test; R --no-save < Canopy_toy.R' | qsub -q bigram -N Canopy_toy


setwd("~/Dropbox/Canopy_shuffle/shuffle")
setwd("C:/Users/yuchaoj/Dropbox/Canopy_shuffle/shuffle")



setwd("/home/stat/yuchaoj/canopy_test")
# firstly we generate the toy dataset where the tree topology is shuffled.
library(Canopy)
sna.name=paste('SNA',1:5,sep='')
cna.name=paste('CNA',1:3,sep='')
sampname=paste('sample',1:10,sep='')

Y=matrix(data=0,ncol=4,nrow=5)
colnames(Y)=c('non_cna_region',cna.name)
rownames(Y)=sna.name
Y[1,2]=1
Y[2,3]=1
Y[3,4]=1
Y[4,1]=1
Y[5,1]=1


k=5  # number of clones
text = paste(paste(paste(paste("(", 1:(k - 1), ",", sep = ""), 
                         collapse = ""), k, sep = ""), paste(rep(")", (k - 1)), 
                                                             collapse = ""), ";", sep = "")

if(k==5){
    text = c('(1,((2,3),(4,5)));')
}


tree <- read.tree(text = text)
plot(tree, label.offset = 0.1, type = "cladogram", direction = "d", 
     show.tip.label = FALSE)
nodelabels()
tiplabels()

tree$sna=initialsna(tree,sna.name)
tree$sna[1,2:3]=c(6,7)
tree$sna[2,2:3]=c(7,8)
tree$sna[3,2:3]=c(9,5)
tree$sna[4,2:3]=c(8,2)
tree$sna[5,2:3]=c(9,4)

tree$Z = getZ(tree, sna.name)

tree$P = initialP(tree, sampname, cell.line=FALSE)
tree$P[,1]=c(0.2,0.2,0.6,0,0)
tree$P[,2]=c(0.2,0,0,0.2,0.6)
tree$P[,3]=c(0.3,0,0,0,0.7)
tree$P[,4]=c(0.3,0,0.7,0,0)
tree$P[,5]=c(0.1,0,0.3,0,0.6)
tree$P[,6]=c(0.2,0,0.45,0,0.35)
tree$P[,7]=c(0.2,0.8,0,0,0)
tree$P[,8]=c(0.2,0,0,0.8,0)
tree$P[,9]=c(0.2,0.2,0,0.6,0)
tree$P[,10]=c(0.2,0.2,0,0,0.6)


tree$cna = initialcna(tree, cna.name)
tree$cna[1,2:3]=c(7,9)
tree$cna[2,2:3]=c(8,3)
tree$cna[3,2:3]=c(7,9)

tree$cna.copy = initialcnacopy(tree)
tree$cna.copy[,1]=c(1,0)
tree$cna.copy[,2]=c(2,1)
tree$cna.copy[,3]=c(2,1)


C = diag(nrow(tree$cna))
colnames(C) = rownames(C) = cna.name

CMCm = getCMCm(tree, C)  # get major and minor copy per clone
tree$CM = CMCm[[1]]
tree$Cm = CMCm[[2]]  # major/minor copy per clone

tree$Q = getQ(tree, Y, C) # whether an SNA procedes a CNA

tree$H = tree$Q  # start as all SNAs that precede CNAs land on major copies

tree$VAF = getVAF(tree, Y)


# generate input for Canopy
R=round(tree$VAF*500)
X=R;X[1:length(X)]=500
epsilonM=epsilonm=0.001
WM=tree$CM%*%tree$P
Wm=tree$Cm%*%tree$P

tree$likelihood = getlikelihood(tree, R, X, WM, Wm, epsilonM, epsilonm)
true.tree=tree
save.image(file='true_tree_shuffle.rda')

toy2=list(R=R,X=X,WM=WM,Wm=Wm,epsilonM=epsilonM,epsilonm=epsilonm,Y=Y,true.tree=true.tree)
save(toy2,file='toy2.rda',compress='xz')

# plot true undelying tree
#true.tree$cna
#canopy.plottree(true.tree)
#canopy.plottree(true.tree,txt = T,txt.name='test.txt',pdf = T, pdf.name='test_tree_topology.pdf')


# then we use canopy to recover the tree topology
projectname='test_tree_topology'
K = 3:6 # number of subclones
numchain = 20 # number of chains with random initiations
sampchain = canopy.sample(R = R, X = X, WM = WM, Wm = Wm, epsilonM = epsilonM, 
                          epsilonm = epsilonm, C = C, Y = Y, K = K, numchain = numchain, 
                          simrun = 100000, writeskip = 200, projectname = projectname,
                          cell.line = FALSE, plot.likelihood = TRUE)
save.image(file = paste(projectname, '_postmcmc_image.rda',sep=''),
           compress = 'xz')



setwd("/home/stat/yuchaoj/canopy_test")

setwd("C:/Users/yuchaoj/Dropbox/Canopy_shuffle/shuffle")
load('test_tree_topology_postmcmc_image.rda')

library(Canopy)

length(sampchain) ## number of subtree spaces (K=3:6)
length(sampchain[[which(K==4)]]) ## number of chains for subtree space with 4 subclones
length(sampchain[[which(K==4)]][[1]]) ## number of posterior trees in each chain

numi=1
sampchain[[which(K==5)]][[numi]][[250]]$edge
sampchain[[which(K==5)]][[numi]][[250]]$likelihood
numi=numi+1




burnin = 100
thin = 10
bic = canopy.BIC(sampchain = sampchain, projectname = projectname, K = K,
                 numchain = numchain, burnin = burnin, thin = thin, pdf = TRUE)
optK = K[which.max(bic)]


post = canopy.post(sampchain = sampchain, projectname = projectname, K = K,
                   numchain = numchain, burnin = burnin, thin = thin, optK = optK,
                   C = C, post.config.cutoff = 0.05)
samptreethin = post[[1]]   # list of all post-burnin and thinning trees
samptreethin.lik = post[[2]]   # likelihoods of trees in samptree
config = post[[3]] # configuration for each posterior tree
config.summary = post[[4]] # configuration summary
print(config.summary)

config.i = config.summary[which.max(config.summary[,3]),1]
cat('Configuration', config.i, 'has the highest posterior likelihood!\n')

# plot first configuration
output.tree = canopy.output(post, 1, C)
canopy.plottree(output.tree,pdf=TRUE,pdf.name=paste(projectname,'_first_config.pdf',sep=''))

# plot second configuration
output.tree = canopy.output(post, 2, C)
canopy.plottree(output.tree,pdf=TRUE,pdf.name=paste(projectname,'_second_config.pdf',sep=''))



