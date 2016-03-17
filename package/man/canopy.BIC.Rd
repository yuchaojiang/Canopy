\name{canopy.BIC}
\alias{canopy.BIC}
\title{
To get BIC as a model selection criterion
}
\description{
To get BIC as a model selection criterion from MCMC sampling results.
}
\usage{
canopy.BIC(sampchain,projectname,K,numchain,burnin,thin,pdf)
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
    MCMC chains thinning}
\item{pdf}{
    whether a pdf plot of BIC should be generated, default to be TRUE}
}
\value{
BIC values (vector) for model selection with plot generated (pdf format).
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_sampchain)
sampchain = MDA231_sampchain
projectname = 'MD231'
K = 3:6
numchain = 20
burnin = 150
thin = 5
bic = canopy.BIC(sampchain = sampchain, projectname = projectname, K = K,
                 numchain = numchain, burnin = burnin, thin = thin)
}
\keyword{ package }