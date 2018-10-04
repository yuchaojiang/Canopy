[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/Canopy)](http://cran.r-project.org/web/packages/Canopy)
[![Downloads](http://cranlogs.r-pkg.org/badges/Canopy)](http://cran.rstudio.com/package=Canopy)

# Canopy

Accessing Intra-Tumor Heterogeneity and Tracking Longitudinal and Spatial Clonal Evolutionary History by Next-Generation Sequencing


## Author
Yuchao Jiang, Nancy R. Zhang

## Maintainer
Yuchao Jiang <yuchaoj@email.unc.edu>


## Description
  A statistical framework and computational procedure for identifying
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


## Installation
* Install the current release from CRAN (updated every 3 months)
```r
install.packages('Canopy')
```

* Install the devel version from GitHub (installation/update from GitHub HIGHLY recommended)
```r
install.packages("ape")
install.packages("fields")
install.packages("pheatmap")
install.packages("scatterplot3d")
install.packages("devtools")
devtools::install_github("yuchaojiang/Canopy/package")
```


## Demo Code & Vignettes
* [Demo codes](https://github.com/yuchaojiang/Canopy/blob/master/demo_code)
* [CRAN](https://cran.r-project.org/web/packages/Canopy/index.html)
* [Vignettes](https://cran.r-project.org/web/packages/Canopy/vignettes/Canopy_vignettes.pdf)
* [SNA clustering](https://github.com/yuchaojiang/Canopy/edit/master/clustering)

<!-- * [Vignettes](https://github.com/yuchaojiang/Canopy/blob/master/package/vignettes/Canopy_vignettes.pdf) -->

## Citation
Jiang, Y., Qiu, Y., Minn, A.J. and Zhang, N.R., 2016. Assessing intratumor heterogeneity and tracking longitudinal and spatial clonal evolutionary history by next-generation sequencing. *Proceedings of the National Academy of Sciences*. [[html](http://www.pnas.org/content/113/37/E5528), [pdf](http://www.pnas.org/content/113/37/E5528.full.pdf)]


## Google User Group (Q&A)
If you have any questions with the package, please feel free to post in our Google user group https://groups.google.com/d/forum/canopy_phylogeny or email us at canopy_phylogeny@googlegroups.com. We will try our best to reply as soon as possible.


## Common Questions

It is HIGHLY recommended that the users read the common questions below carefully before applying Canopy and posting questions in the Google user group.

* [How do I generate SNA and CNA input for Canopy?](https://github.com/yuchaojiang/Canopy/blob/master/instruction/SNA_CNA_input.md)

* [Which CNAs and SNAs should I use?](https://github.com/yuchaojiang/Canopy/blob/master/instruction/SNA_CNA_choice.md)

* [How do I cluster the SNAs?](https://github.com/yuchaojiang/Canopy/edit/master/clustering)

* [What is matrix C? How do I deal with overlapping CNAs?](https://github.com/yuchaojiang/Canopy/blob/master/instruction/overlapping_CNA.md)

* [Error in config.summary/canopy.post?](https://github.com/yuchaojiang/Canopy/blob/master/instruction/config_summary_error.md)

* [What if I only have SNA input?](https://github.com/yuchaojiang/Canopy/blob/master/instruction/sampling_mode.md)

* [How do I get cancer cell fractions (CCFs) for the SNAs?](https://github.com/yuchaojiang/Canopy/blob/master/instruction/CCF.md)
