#######################################################
#######################################################
#######                                         #######
#######             CNA and SNA input           #######
#######                                         #######
#######################################################
#######################################################
library(Canopy)
data("MDA231")
projectname = MDA231$projectname ## name of project
R = MDA231$R; R ## mutant allele read depth (for SNAs)
X = MDA231$X; X ## total depth (for SNAs)
WM = MDA231$WM; WM ## observed major copy number (for CNA regions)
Wm = MDA231$Wm; Wm ## observed minor copy number (for CNA regions)
epsilonM = MDA231$epsilonM ## standard deviation of WM, pre-fixed here
epsilonm = MDA231$epsilonm ## standard deviation of Wm, pre-fixed here
## whether CNA regions harbor specific CNAs (only needed for overlapping CNAs)
C = MDA231$C; C
Y = MDA231$Y; Y ## whether SNAs are affected by CNAs


#######################################################
#######################################################
#######                                         #######
#######               MCMC sampling             #######
#######                                         #######
#######################################################
#######################################################
K = 3:5 # number of subclones
numchain = 15 # number of chains with random initiations
sampchain = canopy.sample(R = R, X = X, WM = WM, Wm = Wm, epsilonM = epsilonM, 
                          epsilonm = epsilonm, C = C, Y = Y, K = K, 
                          numchain = numchain, max.simrun = 100000,
                          min.simrun = 20000, writeskip = 200,
                          projectname = projectname, cell.line = TRUE,
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
projectname='MDA231'
load(paste(projectname, '_postmcmc_image.rda', sep=''))
burnin = 100
thin = 5
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
                   optK = optK, C = C, post.config.cutoff = 0.05)
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
output.tree = canopy.output(post, config.i, C)
pdf.name = paste(projectname, '_config_highest_likelihood.pdf', sep='')
canopy.plottree(output.tree, pdf = TRUE, pdf.name = pdf.name)

# plot posterior tree with third configuration
output.tree = canopy.output(post, 3, C)
canopy.plottree(output.tree, pdf=TRUE, pdf.name = paste(projectname, '_third_config.pdf', sep = ''))

