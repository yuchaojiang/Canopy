\name{canopy.cluster}
\alias{canopy.cluster}
\title{
    EM algorithm for multivariate clustering of SNAs
}
\description{
    EM algorithm for multivariate clustering of SNAs.
}
\usage{
    canopy.cluster(R, X, num_cluster, num_run, Mu.init = NULL, Tau_Kplus1 = NULL)
}
\arguments{
    \item{R}{
        alternative allele read depth matrix}
    \item{X}{
        total read depth matrix}
    \item{num_cluster}{
        number of mutation clusters (BIC as model selection metric)}
    \item{num_run}{
        number of EM runs for estimation for each specific number of clusters 
        (to avoid EM being stuck in local optima)}
    \item{Mu.init}{
        (optional) initial value of the VAF centroid for each mutation cluster
        in each sample}
    \item{Tau_Kplus1}{
        (optional) pre-specified proportion of noise component in clustering,
        uniformly distributed between 0 and 1
    }
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