\name{sampcna}
\alias{sampcna}
\title{
To sample CNA positions
}
\description{
To sample CNA positions along the tree. Used in \code{\link{canopy.sample}}.
}
\usage{
sampcna(tree)
}
\arguments{
\item{tree}{
    input tree}
}
\value{
Newly sampled matrix specifying positions of CNAs (start and end node).
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
sampcna(MDA231_tree)
}
\keyword{ package }