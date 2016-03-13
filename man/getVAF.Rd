\name{getVAF}
\alias{getVAF}
\title{
To get variant allele frequency (VAF)
}
\description{
To get variant allele frequency (VAF) matrix, which contains percentage of 
mutant SNA alleles across samples. Used in \code{\link{canopy.sample}}.
}
\usage{
getVAF(tree,Y)
}
\arguments{
\item{tree}{
    input tree}
\item{Y}{
    SNA CNA overlapping matrix}
}
\value{
Variant allele frequency matrix VAF.
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
data(MDA231)
Y = MDA231$Y
getVAF(MDA231_tree, Y)
}
\keyword{ package }