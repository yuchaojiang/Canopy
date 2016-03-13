\name{initialsna}
\alias{initialsna}
\title{
To initialize positions of SNAs
}
\description{
To initialize positions of SNAs on the tree. Used in initialization step of
\code{\link{canopy.sample}}.
}
\usage{
initialsna(tree,sna.name)
}
\arguments{
\item{tree}{
    input tree}
\item{sna.name}{
    vector of input SNA names}
}
\value{
Matrix specifying positions of SNAs (start and end node).
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
data(MDA231)
sna.name = rownames(MDA231$R)
initialsna(MDA231_tree, sna.name)
}
\keyword{ package }