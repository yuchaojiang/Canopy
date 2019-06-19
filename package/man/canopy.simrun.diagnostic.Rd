\name{canopy.simrun.diagnostic}
\alias{canopy.simrun.diagnostic}
\title{
Diagnostic tool for run length
}
\description{
outputs a plot to ensure that individual chains have converged.  User adjusts the y range to focus on maximum likelihood 
}
\usage{
canopy.simrun.diagnostic(sampchain, optK, K, writeskip, yRange)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\item{sampchain}{
    sampchain from canopy.sample() or variation}
\item{optK}{
    optK as determined by canopy.BIC() }
\item{K}{
    clusters tested}
\item{writeskip}{
    writeskip parameter used in canopy.sample()}
\item{yRange}{
    set y limits of plot from ( max likelihood - yRange ) to max likelihood }
}
\value{
plot of likelihood for each chain 
}
\author{
Gene Urrutia \email{urrutia@email.unc.edu}
}

\examples{

canopy.simrun.diagnostic (sampchain, optK, K, writeskip, yRange = 100 )
}

\keyword{ package }
