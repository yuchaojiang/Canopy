\name{initialcna}
\alias{initialcna}
\title{
To initialize positions of CNAs
}
\description{
To initialize positions of CNAs on the tree. Used in initialization step of
\code{\link{canopy.sample}}.
}
\usage{
initialcna(tree,cna.name)
}
\arguments{
\item{tree}{
    input tree}
\item{cna.name}{
    vector of input CNA names}
}
\value{
Matrix specifying positions of CNAs (start and end node).
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
data(MDA231)
cna.name = rownames(MDA231$WM)
initialcna(MDA231_tree, cna.name)
}
\keyword{ package }