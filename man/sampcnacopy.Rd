\name{sampcnacopy}
\alias{sampcnacopy}
\title{
To sample major and minor copies of CNAs
}
\description{
To sample major and minor copies of CNAs. Used in \code{\link{canopy.sample}}.
}
\usage{
sampcnacopy(tree)
}
\arguments{
\item{tree}{
    input tree}
}
\value{
Newly sampled matrix specifying major and minor copies of CNAs.
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
sampcnacopy(MDA231_tree)
}
\keyword{ package }