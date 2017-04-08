\name{canopy.sample.nocna}
\alias{canopy.sample.nocna}
\title{
    MCMC sampling in tree space
}
\description{
    To sample the posterior trees without CNA input. Major function of Canopy.
}
\usage{
    canopy.sample.nocna(R, X, K, numchain, max.simrun, min.simrun, writeskip, 
                  projectname, cell.line=NULL, plot.likelihood=NULL)
}
\arguments{
    \item{R}{
        alternative allele read depth matrix}
    \item{X}{
        total read depth matrix}
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
    data(toy3)
    R = toy3$R; X = toy3$X
    K = 3:5
    numchain = 10
    projectname = 'toy3'
    # sampchain = canopy.sample.nocna(R = R, X = X, K = K, numchain = numchain, 
    #             max.simrun = 50000, min.simrun = 10000, writeskip = 200, 
    #             projectname = projectname,
    #             cell.line = TRUE, plot.likelihood = TRUE)
}
\keyword{ package }