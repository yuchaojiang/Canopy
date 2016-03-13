\name{getCZ}
\alias{getCZ}
\title{
To get CNA genotyping matrix CZ
}
\description{
To get CNA genotyping matrix CZ from location of CNAs on the tree. Used in
\code{\link{canopy.sample}}.
}
\usage{
getCZ(tree)
}
\arguments{
\item{tree}{
    input tree}
}
\value{
CNA genotyping matrix CZ.
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
getCZ(MDA231_tree)
}
\keyword{ package }