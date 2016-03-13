\name{canopy.plottree}
\alias{canopy.plottree}
\title{
To plot tree inferred by Canopy
}
\description{
To plot Canopy's reconstructed phylogeny. Major plotting function of Canopy.
}
\usage{
canopy.plottree(tree,pdf,pdf.name)
}
\arguments{
\item{tree}{
    input tree to be plotted}
\item{pdf}{
    whether a pdf plot should be generated, default to be TRUE}
\item{pdf.name}{
    name of pdf to be generated, has to be provided if pdf is to be generated}
}
\value{
Plot of tree structure, clonal frequency and mutation legends (pdf format).
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
pdf.name = 'MDA231_tree.pdf'
canopy.plottree(MDA231_tree, pdf = TRUE, pdf.name = pdf.name)
}
\keyword{ package }