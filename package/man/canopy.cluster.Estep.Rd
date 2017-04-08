\name{canopy.cluster.Estep}
\alias{canopy.cluster.Estep}
\title{
    E-step of EM algorithm for multivariate clustering of SNAs
}
\description{
    E-step of EM algorithm for multivariate clustering of SNAs. Used in
    \code{\link{canopy.cluster}}.
}
\usage{
    canopy.cluster.Estep(Tau, Mu, R, X)
}
\arguments{
    \item{Tau}{
        prior for proportions of mutation clusters}
    \item{Mu}{
        MAF centroid for each mutation cluster in each sample}
    \item{R}{
        alternative allele read depth matrix}
    \item{X}{
        total read depth matrix}
}
\value{
    Matrix of posterior probability of cluster assignment for each mutation.}
\author{
    Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
    data(AML43)
    R = AML43$R
    X = AML43$X
    Mu = AML43$Mu
    Tau = AML43$Tau
    pG = canopy.cluster.Estep(Tau, Mu, R, X)
}
\keyword{ package }