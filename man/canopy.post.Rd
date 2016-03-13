\name{canopy.post}
\alias{canopy.post}
\title{
Posterior evaluation of MCMC sampled trees
}
\description{
Burnin, thinning, and posterior evaluation of MCMC sampled trees.
}
\usage{
canopy.post(sampchain, projectname, K, numchain, burnin, thin, optK,
            C, post.config.cutoff)
}
\arguments{
\item{sampchain}{
    list of sampled trees returned by \code{\link{canopy.sample}}}
\item{projectname}{
    name of project}
\item{K}{
    number of subclones (vector)}
\item{numchain}{
    number of MCMC chains with random initiations}
\item{burnin}{
    burnin of MCMC chains}
\item{thin}{
    MCMC chain thinning.}
\item{optK}{
    optimal number of subclones determined by \code{\link{canopy.BIC}}}
\item{C}{
    CNA and CNA-region overlapping matrix, only needed if overlapping CNAs are
    used as input}
\item{post.config.cutoff}{
    cutoff value for posterior probabilities of tree configurations,
    default is set to be 0.05 (only tree configurations with greater
    than 0.05 posterior probabilities will be reported by Canopy)}
}
\value{
\item{samptreethin}{
    list of sampled posterior trees}
\item{samptreethin.lik}{
    vector of likelihood of sampled posterior trees}
\item{config}{
    vector of configuration of sampled posterior trees (integer values)}
\item{config.summary}{
    summary of configurations of sampled posterior trees}
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_sampchain)
data(MDA231)
sampchain = MDA231_sampchain
projectname = 'MD231'
K = 3:6
numchain = 20
burnin = 150
thin = 5
optK = 4
C = MDA231$C
post = canopy.post(sampchain = sampchain, projectname = projectname, K = K,
                   numchain = numchain, burnin = burnin, thin = thin, 
                   optK = optK, C = C)
}
\keyword{ package }