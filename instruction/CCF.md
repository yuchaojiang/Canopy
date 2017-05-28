## **How do I get cancer cell fractions (CCFs) for the SNAs?**
  
  Cancer cell fractions (CCFs) refer to the fractions of cancer cells (not including the normal cell contamination) that harbor specific mutations. To get the CCF for a specific posterior tree, for example, the maximum likelihood tree, use the code below.

```r
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

K = 3:5 # number of subclones
numchain = 15 # number of chains with random initiations
data("MDA231_sampchain")
sampchain=MDA231_sampchain # pre-computed and stored as part of Canopy's package

burnin = 100; thin = 5
bic = canopy.BIC(sampchain = sampchain, projectname = projectname, K = K,
                 numchain = numchain, burnin = burnin, thin = thin, pdf = TRUE)
optK = K[which.max(bic)]

post = canopy.post(sampchain = sampchain, projectname = projectname, K = K,
                   numchain = numchain, burnin = burnin, thin = thin, 
                   optK = optK, C = C, post.config.cutoff = 0.05)
samptreethin = post[[1]]   # list of all post-burnin and thinning trees
samptreethin.lik = post[[2]]   # likelihoods of trees in samptree
config = post[[3]]
config.summary = post[[4]]
print(config.summary)

# choose the configuration with the highest posterior likelihood
config.i = config.summary[which.max(config.summary[,3]),1]
cat('Configuration', config.i, 'has the highest posterior likelihood.\n')
output.tree = canopy.output(post, config.i, C)
output.tree$CCF
```

  To get CCFs for posterior trees with the same configurations, use the code below (the above needs to be run first).
 ```r
 length(samptreethin) # posterior trees
length(config) # configuration for posteior trees
samptreethin.config1=samptreethin[which(config==1)] # posterior trees with configuration 1
table(config)
length(samptreethin.config1)
samptreethin.config1[[1]]$CCF
samptreethin.config1[[2]]$CCF
samptreethin.config1[[77]]$CCF
# mean and s.d. can be computed across all 77 trees with configuration 1
 ```

