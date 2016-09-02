\name{canopy.plottree}
\alias{canopy.plottree}
\title{
To plot tree inferred by Canopy
}
\description{
To plot Canopy's reconstructed phylogeny. Major plotting function of Canopy.
}
\usage{
canopy.plottree(tree, pdf, pdf.name, txt, txt.name)
}
\arguments{
\item{tree}{
    input tree to be plotted}
\item{pdf}{
    whether a pdf plot should be generated, default to be FALSE}
\item{pdf.name}{
    name of pdf to be generated, has to be provided if pdf is to be generated}
\item{txt}{
    whether a txt file should be generated with information on mutations along 
    the tree branches, default to be FALSE}
\item{txt.name}{
    name of txt to be generated, has to be provided if txt is to be generated}
}
\value{
Plot of tree structure, clonal frequency and mutation legends (pdf format).
}
\author{
Yuchao Jiang \email{yuchaoj@wharton.upenn.edu}
}
\examples{
data(MDA231_tree)
canopy.plottree(MDA231_tree, pdf = TRUE, pdf.name = 'MDA231_tree.pdf')
}
\keyword{ package }