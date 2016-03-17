\name{sortcna}
\alias{sortcna}
\title{
To sort identified overlapping CNAs.
}
\description{
To sort identified overlapping CNAs by their major and minor copy numbers.
Used in \code{\link{canopy.post}}.
}
\usage{
sortcna(tree,C)
}
\arguments{
\item{tree}{
    input tree}
\item{C}{
    CNA and CNA-region overlapping matrix}
}
\value{
Tree whose overlapping CNAs are sorted by major and minor copy numbers.
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
data(MDA231)
C = MDA231$C
sortcna(MDA231_tree, C)
}
\keyword{ package }