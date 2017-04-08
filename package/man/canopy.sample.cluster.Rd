\name{canopy.sample.cluster}
\alias{canopy.sample.cluster}
\title{
    MCMC sampling in tree space with pre-clustering of SNAs
}
\description{
    To sample the posterior trees with pre-clustering step of SNAs. Major
    function of Canopy.
}
\usage{
    canopy.sample.cluster(R, X, sna_cluster, WM, Wm, epsilonM, epsilonm, C=NULL,
                  Y, K, numchain, max.simrun, min.simrun, writeskip, projectname,
                  cell.line=NULL, plot.likelihood=NULL)
}
\arguments{
    \item{R}{
        alternative allele read depth matrix}
    \item{X}{
        total read depth matrix}
    \item{sna_cluster}{
        cluster assignment for each mutation from the EM Binomial clustering
        algorithm
    }
    \item{WM}{
        observed major copy number matrix}
    \item{Wm}{
        observed minor copy number matrix}
    \item{epsilonM}{
        observed standard deviation of major copy number (scalar input is
                                                          transformed into matrix)}
    \item{epsilonm}{
        observed standard deviation of minor copy number (scalar input is
                                                          transformed into matrix)}
    \item{C}{
        CNA and CNA-region overlapping matrix, only needed if overlapping CNAs are
        used as input}
    \item{Y}{
        SNA and CNA-region overlapping matrix}
    \item{K}{
        number of subclones (vector)}
    \item{numchain}{
        number of MCMC chains with random initiations}
    \item{max.simrun}{
        maximum number of simutation iterations for each chain}
    \item{min.simrun}{
        minimum number of simutation iterations for each chain}
    \item{writeskip}{
        interval to store sampled trees}
    \item{projectname}{
        name of project}
    \item{cell.line}{
        default to be FALSE, TRUE if input sample is cell line (no normal cell
                                                                contamination)}
    \item{plot.likelihood}{
        default to be TRUE, posterior likelihood plot generated for check of
        convergence and selection of burnin and thinning in
        \code{\link{canopy.post}}}
}
\value{
    List of sampleed trees in subtree space with different number of subclones;
    plot of posterior likelihoods in each subtree space generated (pdf format).}
\author{
    Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
    data(MDA231)
    R = MDA231$R; X = MDA231$X
    WM = MDA231$WM; Wm = MDA231$Wm
    epsilonM = MDA231$epsilonM; epsilonm = MDA231$epsilonm
    C = MDA231$C
    Y = MDA231$Y
    K = 3:6
    numchain = 20
    projectname = 'MDA231'
    # sampchain = canopy.sample.cluster(R = R, X = X, sna_cluster=c(1,2,3,4),
    #             WM = WM, Wm = Wm, epsilonM = epsilonM, 
    #             epsilonm = epsilonm, C = C, Y = Y, K = K, numchain = numchain, 
    #             max.simrun = 50000, min.simrun = 10000, writeskip = 200, 
    #             projectname = projectname, cell.line = TRUE, plot.likelihood = TRUE)
}
\keyword{ package }