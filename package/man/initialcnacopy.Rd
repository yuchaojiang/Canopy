\name{initialcnacopy}
\alias{initialcnacopy}
\title{
To initialize major and minor copies of CNAs
}
\description{
To initialize major and minor copies of CNAs. Used in initialization step of
\code{\link{canopy.sample}}.
}
\usage{
initialcnacopy(tree)
}
\arguments{
\item{tree}{
    input tree}
}
\value{
Matrix specifying major and minor copies of CNAs.
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
initialcnacopy(MDA231_tree)
}
\keyword{ package }