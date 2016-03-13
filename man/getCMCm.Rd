\name{getCMCm}
\alias{getCMCm}
\title{
To get major and minor copy per clone
}
\description{
To get major and minor copy per clone. Used in \code{\link{canopy.sample}}.
}
\usage{
getCMCm(tree, C)
}
\arguments{
\item{tree}{
    input tree}
\item{C}{
    CNA regions and CNA overlapping matrix}
}
\value{
\item{CM}{
    Matrix of major copy per clone.}
\item{Cm}{
    Matrix of minor copy per clone.}
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
data(MDA231)
C = MDA231$C
getCMCm(MDA231_tree, C)
}
\keyword{ package }