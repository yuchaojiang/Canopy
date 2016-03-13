\name{sampP}
\alias{sampP}
\title{
To sample clonal frequency
}
\description{
To sample clonal frequency matrix \eqn{P}. Used in \code{\link{canopy.sample}}.
}
\usage{
sampP(tree, cell.line)
}
\arguments{
\item{tree}{
    input tree}
\item{cell.line}{
    default to be FALSE, TRUE if input sample is cell line (no normal cell
    contamination)}
}
\value{
Newly sampled clonal frequency matrix \eqn{P}.
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
sampP(MDA231_tree, cell.line = TRUE)
}
\keyword{ package }