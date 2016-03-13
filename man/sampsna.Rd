\name{sampsna}
\alias{sampsna}
\title{
To sample SNA positions
}
\description{
To sample SNA positions along the tree. Used in \code{\link{canopy.sample}}.
}
\usage{
sampsna(tree)
}
\arguments{
\item{tree}{
    input tree}
}
\value{
Newly sampled matrix specifying positions of SNAs (start and end node).
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
sampsna(MDA231_tree)
}
\keyword{ package }