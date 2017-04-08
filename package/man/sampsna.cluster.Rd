\name{sampsna.cluster}
\alias{sampsna.cluster}
\title{
    To sample positions of SNA clusters
}
\description{
    To sample SNA cluster positions along the tree. Used in 
    \code{\link{canopy.sample.cluster}} and \code{\link{canopy.sample.cluster.nocna}}.
}
\usage{
    sampsna.cluster(tree)
}
\arguments{
    \item{tree}{input tree}
}
\value{
    Newly sampled matrix specifying positions of SNA clusters (start and end node).
}
\author{
    Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
    data(MDA231_tree)
    MDA231_tree$sna.cluster=initialsna(MDA231_tree,paste('cluster',1:4,sep=''))
    sampsna.cluster(MDA231_tree)
}
\keyword{ package }