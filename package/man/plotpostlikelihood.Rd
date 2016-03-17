\name{plotpostlikelihood}
\alias{plotpostlikelihood}
\title{
To plot posterior likelihood
}
\description{
To plot posterior likelihood of sampled trees from MCMC. Can be used to check
convergence of sampling and determine cutoff values for burnin and thinning.
Used in \code{\link{canopy.sample}}.
}
\usage{
plotpostlikelihood(sampchaink,projectname,k,numchain)
}
\arguments{
\item{sampchaink}{
    list of sampled trees with \eqn{k} subclones}
\item{projectname}{
    name of project}
\item{k}{
    number of subclones}
\item{numchain}{
    number of MCMC chains with random initiations}
}
\value{
Plot of posterior likelihood of trees in subtree space with specific number of
subclones (pdf format).
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_sampchain)
k = 3
K = 3:6
sampchaink = MDA231_sampchain[[which(K == k)]]
projectname = 'MDA231'
numchain = 20
plotpostlikelihood(sampchaink, projectname, k = k, numchain)
}
\keyword{ package }