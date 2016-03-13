\name{initialP}
\alias{initialP}
\title{
To initialize clonal frequency matrix
}
\description{
To initialize clonal frequency matris \eqn{P}. Used in initialization step of
\code{\link{canopy.sample}}.
}
\usage{
initialP(tree,sampname,cell.line)
}
\arguments{
\item{tree}{
    input tree}
\item{sampname}{
    vector of input sample names}
\item{cell.line}{
    default to be FALSE, TRUE if input sample is cell line (no normal cell
    contamination)}
}
\value{
Clonal frequency matrix \eqn{P}.
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
data(MDA231)
sampname = colnames(MDA231$R)
initialP(MDA231_tree, sampname, cell.line = TRUE)
}
\keyword{ package }