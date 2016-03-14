[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/Canopy)](http://cran.r-project.org/web/packages/Canopy)
[![Downloads](http://cranlogs.r-pkg.org/badges/Canopy)](http://cran.rstudio.com/package=Canopy)

# Canopy


## Install the current release from CRAN:
```r
install.packages('Canopy')
```


Package: Canopy

Type: Package
Title: Accessing Intra-Tumor Heterogeneity and Tracking Longitudinal and Spatial
  Clonal Evolutionary History by Next-Generation Sequencing

Version: 1.0.2

Author: Yuchao Jiang, Nancy R. Zhang

Maintainer: Yuchao Jiang <yuchaoj@wharton.upenn.edu>

Description: A statistical framework and computational procedure for identifying
  the sub-populations within a tumor, determining the mutation profiles of each 
  subpopulation, and inferring the tumor's phylogenetic history. The input are 
  variant allele frequencies (VAFs) of somatic single nucleotide alterations 
  (SNAs) along with allele-specific coverage ratios between the tumor and matched
  normal sample for somatic copy number alterations (CNAs). These quantities can
  be directly taken from the output of existing software. Canopy provides a 
  general mathematical framework for pooling data across samples and sites to 
  infer the underlying parameters. For SNAs that fall within CNA regions, Canopy
  infers their temporal ordering and resolves their phase.  When there are 
  multiple evolutionary configurations consistent with the data, Canopy outputs 
  all configurations along with their confidence assessment.

License: GPL-2

Depends: R (>= 3.2), ape, fields

Imports: grDevices, graphics, stats

URL: https://sites.google.com/a/cornell.edu/yuchaojiang/home/research/canopy
