\name{canopy.cluster.Mstep}
\alias{canopy.cluster.Mstep}
\title{
    M-step of EM algorithm for multivariate clustering of SNAs
}
\description{
    M-step of EM algorithm for multivariate clustering of SNAs. Used in
    \code{\link{canopy.cluster}}.
}
\usage{
    canopy.cluster.Mstep(pG, R, X, Tau_Kplus1)
}
\arguments{
    \item{pG}{
        matrix of posterior probability of cluster assignment for each mutation}
    \item{R}{
        alternative allele read depth matrix}
    \item{X}{
        total read depth matrix}
    \item{Tau_Kplus1}{
        proportion mutation cluster that is uniformly distributed to capture noise}
}
\value{
    List of bic, converged Mu, Tau, and SNA cluster assignment.}
\author{
    Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
    data(AML43)
    R = AML43$R; X = AML43$X
    num_cluster = 4 # Range of number of clusters to run
    num_run = 6 # How many EM runs per clustering step
    Tau_Kplus1=0.05 # Proportion of noise component
    Mu.init=cbind(c(0.01,0.15,0.25,0.45),c(0.2,0.2,0.01,0.2)) # initial value
                                                              # of centroid
    canopy.cluster=canopy.cluster(R = R, X = X, num_cluster = num_cluster,
                                  num_run = num_run, Mu.init = Mu.init,
                                  Tau_Kplus1=Tau_Kplus1)
}
\keyword{ package }