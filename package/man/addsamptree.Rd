\name{addsamptree}
\alias{addsamptree}
\title{
To determine whether the sampled tree will be accepted
}
\description{
To determine whether the sampled tree will be accepted by comparing the
likelihood, used in \code{\link{canopy.sample}.}
}
\usage{
addsamptree(tree,tree.new)
}
\arguments{
\item{tree}{
    input tree (current)}
\item{tree.new}{
    input tree (newly sampled)}
}
\value{
returned tree (either retain the old tree or accept the new tree).
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231)
data(MDA231_tree)
sna.name = MDA231$sna.name
Y = MDA231$Y
C = MDA231$C
R = MDA231$R
X = MDA231$X
WM = MDA231$WM
Wm = MDA231$Wm
epsilonM = MDA231$epsilonM
epsilonm = MDA231$epsilonm
# sampling location of SNAs
tree.new = MDA231_tree
tree.new$sna = sampsna(MDA231_tree)
tree.new$Z = getZ(tree.new, sna.name)
tree.new$Q = getQ(tree.new, Y, C)
tree.new$H = tree.new$Q
tree.new$VAF = getVAF(tree.new, Y)
tree.new$likelihood = getlikelihood(tree.new, R, X, WM, Wm, epsilonM, epsilonm)
tree = addsamptree(MDA231_tree,tree.new)
}
\keyword{ package }