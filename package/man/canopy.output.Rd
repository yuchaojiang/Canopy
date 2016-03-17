\name{canopy.output}
\alias{canopy.output}
\title{
To generate a posterior tree
}
\description{
To generate a posterior tree from the sub-tree space of trees with the same
configurations.
}
\usage{
canopy.output(post, config.i, C)
}
\arguments{
\item{post}{
    list returned by \code{\link{canopy.post}}}
\item{config.i}{
    configuration of sub-tree space to be output}
\item{C}{
    CNA and CNA-region overlapping matrix, only needed if overlapping CNAs are
    used as input}
}
\value{
posterior tree from the sub-tree space of trees with the same configurations.
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
config.i = 3
output.tree = canopy.output(post = post, config.i = config.i, C = C)
}
\keyword{ package }