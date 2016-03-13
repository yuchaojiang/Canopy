\name{getlikelihood}
\alias{getlikelihood}
\title{
To get likelihood of the tree
}
\description{
To get likelihood of the tree given tree struture and data input. Used in
\code{\link{canopy.sample}}.
}
\usage{
getlikelihood(tree,R,X,WM,Wm,epsilonM,epsilonm)
}
\arguments{
\item{tree}{
    input tree}
\item{R}{
    alternative allele read depth matrix}
\item{X}{
    total read depth matrix}
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
WM = MDA231$WM
Wm = MDA231$Wm
epsilonM = MDA231$epsilonM
epsilonm = MDA231$epsilonm
getlikelihood(MDA231_tree, R, X, WM, Wm, epsilonM, epsilonm)
}
\keyword{ package }