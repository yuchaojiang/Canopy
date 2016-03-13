\name{getclonalcomposition}
\alias{getclonalcomposition}
\title{
To get clonal composition
}
\description{
To get clonal composition (mutational profile of each clone) of tree. Used in
\code{\link{canopy.post}}.
}
\usage{
getclonalcomposition(tree)
}
\arguments{
\item{tree}{
    input tree}
}
\value{
List of each clone's mutational profile.
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
getclonalcomposition(MDA231_tree)
}
\keyword{ package }