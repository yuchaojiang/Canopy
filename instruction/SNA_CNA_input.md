[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/Canopy)](http://cran.r-project.org/web/packages/Canopy)
[![Downloads](http://cranlogs.r-pkg.org/badges/Canopy)](http://cran.rstudio.com/package=Canopy)

# Canopy

Accessing Intra-Tumor Heterogeneity and Tracking Longitudinal and Spatial Clonal Evolutionary History by Next-Generation Sequencing


## Author
Yuchao Jiang, Nancy R. Zhang

## Maintainer
Yuchao Jiang <yuchaoj@upenn.edu>


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
* Install the current release from CRAN
```r
install.packages('Canopy')
```

* Install the devel version from GitHub
```r
install.packages("fields")
install.packages("devtools")
library(devtools)
install_github("yuchaojiang/Canopy/package")
```


## Demo Code & Vignettes
* [Demo code](https://github.com/yuchaojiang/Canopy/blob/master/demo_code/Canopy_demo.R)
* [CRAN](https://cran.r-project.org/web/packages/Canopy/index.html)
* [Vignettes](https://cran.rstudio.com/web/packages/Canopy/vignettes/Canopy_vignettes.pdf)


## Citation
Jiang, Y., Qiu, Y., Minn, A.J. and Zhang, N.R., 2016. Assessing intratumor heterogeneity and tracking longitudinal and spatial clonal evolutionary history by next-generation sequencing. *Proceedings of the National Academy of Sciences*. [[html](http://www.pnas.org/content/early/2016/08/26/1522203113), [pdf](http://www.pnas.org/content/early/2016/08/26/1522203113.full.pdf)]


## Google User Group (Q&A)
If you have any questions with the package, please feel free to post in our Google user group https://groups.google.com/d/forum/canopy_phylogeny or email us at canopy_phylogeny@googlegroups.com. We will try our best to reply as soon as possible.


## Common Questions
* **[How do I generate SNA and CNA input for Canopy?](https://github.com/yuchaojiang/Canopy/blob/master/instruction/SNA_CNA_input.md)**

* **Which CNAs and SNAs should I use?**
  
  How to generate a clean set of input to Canopy is important and non-trivial. While in our phylogeney reconstruction paper we were not trying to solve this tricky but separate problem of quality control of copy number calls, an input with too many false positives will only lead to "garbage in garbage out" by Canopy. We are currently working on automating the pipeline for generating CNA and SNA input as well as offering guidance to select the ***informative*** SNAs and CNAs. By saying ***informative***, we mean that the SNAs or CNAs show distinct patterns between different samples (from the same patient since we are looking at intratumor heterogeneity). For SNAs, this means that the observed VAFs are different (see Figure 4B in our paper) and in this case a heatmap is a good way for visualization. For CNAs, this means that the WM and Wm are different (see Supplementary Figure S13 in our paper) and we find [IGV](http://software.broadinstitute.org/software/igv/) a good tool for visualization and recommend focusing on large CNA regions, which helps remove false calls and speed up computation.
  
  Just like SNAs, there will likely to be CNAs carried by small fractions of the cells, or that reside in hard-to-call regions of the genome, which are not detected. The former scenario, in particular, includes CNAs which may be informative about rare subclones. We do not assume that the CNAs (and SNAs) given to Canopy comprise all mutations that are carried by the sample, and similarly, do not attempt to claim that Canopy detects all subclones or resolves all branches of the evolutionary tree. Our goal is only to estimate all of the subclones that have representation among the set of input CNAs and SNAs, which are, inherently, limited in resolution by the experimental protocol (sequencing platform and coverage, number of tumor slices, etc.) We believe this is the best that can be achieved under current settings.
  
* **What is matrix C?**

  Matrix C is only needed if overlapping CNAs are used as input -- if there is no overlapping CNA, C can be left as null. If there are overlapping CNA events, the columns of the C matrix are the CNA ***events*** and the rows are the CNA ***regions***.
  
  As an example from the vignettes below, we know from the profiled CNAs (ses Supplementary Figure S13) in our paper that two CNA events hit the same BRAF region on chr7 and that two CNA events hit the same KRAS region on chr12. There are altogether four CNA regions and six CNA events. The C matrix specifies whether CNA regions harbor specific CNA events. In the case of overlapping CNAs, manual inspection is needed to identify mixture of CNA events with different copy number changes or different breakpoints.
  
  |            |     chr7_1 |    chr7_2 |     chr12_1 |    chr12_2 | chr18 | chr19 |
  |------------|------------|-----------|-------------|------------|-------|-------|
  |        chr7|       1    |      1    |       0     |       0    |   0   |   0   |
  |       chr12|       0    |      0    |       1     |       1    |   0   |   0   |
  |       chr18|       0    |      0    |       0     |       0    |   1   |   0   |
  |       chr19|       0    |      0    |       0     |       0    |   0   |   1   |


