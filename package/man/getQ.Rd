\name{getQ}
\alias{getQ}
\title{
To get SNA-CNA genotyping matrix
}
\description{
To get SNA-CNA genotyping matrix \eqn{Q}, which specifies whether an SNA
precedes a CNA. Used in \code{\link{canopy.sample}}.
}
\usage{
getQ(tree, Y, C)
}
\arguments{
\item{tree}{
    input tree}
\item{Y}{
    SNA CNA overlapping matrix}
\item{C}{
    CNA and CNA region overlapping matrix}
}
\value{
Genotyping matrix \eqn{Q}.
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
data(MDA231)
Y = MDA231$Y
C = MDA231$C
getQ(MDA231_tree, Y, C)
}
\keyword{ package }