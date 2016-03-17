\name{getZ}
\alias{getZ}
\title{
To get SNA genotyping matrix \eqn{Z}
}
\description{
To get SNA genotyping matrix \eqn{Z} from location of SNAs on the tree. Used in
\code{\link{canopy.sample}}.
}
\usage{
getZ(tree, sna.name)
}
\arguments{
\item{tree}{
    input tree}
\item{sna.name}{
    vector of SNA names}
}
\value{
Genotyping matrix \eqn{Z}.
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
data(MDA231)
sna.name = rownames(MDA231$R)
getZ(MDA231_tree, sna.name)
}
\keyword{ package }