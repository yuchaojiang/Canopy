#######################################################
#######################################################
#######                                         #######
#######             Try it yourself             #######
#######                                         #######
#######################################################
#######################################################
library(Canopy)
data(toy2)
projectname = 'toy2'
R = toy2$R; X = toy2$X; WM = toy2$WM; Wm = toy2$Wm
epsilonM = toy2$epsilonM; epsilonm = toy2$epsilonm; Y = toy2$Y
true.tree = toy2$true.tree  # true underlying tree

K = 3:6; numchain = 20
sampchain = canopy.sample(R = R, X = X, WM = WM, Wm = Wm, epsilonM = epsilonM, 
                          epsilonm = epsilonm, C = NULL, Y = Y, K = K, 
                          numchain = numchain, simrun = 100000, writeskip = 200,
                          projectname = projectname, cell.line = FALSE,
                          plot.likelihood = TRUE)
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
data(toy2)
projectname='toy2'

load(paste(projectname, '_postmcmc_image.rda', sep=''))
burnin = 100
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
                   optK = optK, post.config.cutoff = 0.05)
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
canopy.plottree(output.tree, pdf = TRUE, pdf.name = pdf.name)
canopy.plottree(output.tree, pdf = FALSE)
