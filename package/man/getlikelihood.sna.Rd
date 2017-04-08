\name{getlikelihood.sna}
\alias{getlikelihood.sna}
\title{
    To get SNA likelihood of the tree
}
\description{
    To get SNA likelihood of the tree given tree struture and data input. Used in
    \code{\link{canopy.sample.nocna}} and \code{\link{canopy.sample.cluster.nocna}}.
}
\usage{
    getlikelihood.sna(tree, R, X)
}
\arguments{
    \item{tree}{
        input tree}
    \item{R}{
        alternative allele read depth matrix}
    \item{X}{
        total read depth matrix}
}
\value{
    Likelihood of sampled tree.}
\author{
    Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
    data(MDA231)
    data(MDA231_tree)
    R = MDA231$R
    X = MDA231$X
    getlikelihood.sna(MDA231_tree, R, X)
}
\keyword{ package }