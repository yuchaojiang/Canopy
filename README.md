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
* How do I generate SNA and CNA input for Canopy?
  
  * We use UnifiedGenotyper by [GATK](https://software.broadinstitute.org/gatk/) to call somatic SNAs and follow its [Best Practices](https://software.broadinstitute.org/gatk/best-practices/). A demo code can be found [here](https://github.com/yuchaojiang/Canopy/blob/master/instruction/UnifiedGenotyper.sh).
  * To generate allele-specific copy number calls, [Sequenza](https://cran.r-project.org/web/packages/sequenza/index.html) (see below) or [FALCON-X](https://cran.fhcrc.org/web/packages/falconx/index.html) (instructions to follow soon) can be used.
  
    Below is output of chr11 from Sequenza. 
  
    ![sequenza_seg] (https://github.com/yuchaojiang/Canopy/blob/master/instruction/sequenza_seg.png)
  
    ![sequenza_view] (https://github.com/yuchaojiang/Canopy/blob/master/instruction/sequenza_view.png)
  
    The B-allele frequency is Bf = Wm / (WM + Wm) and the depth ratio is depth.ratio = (WM + Wm)/2. From here the input matrix WM and Wm can be calculated.

* Which CNAs and SNAs should I use?
  
  How to generate a clean set of input to Canopy is non-trivial. While this is not the main focus of our phylogeny reconstruction paper, an input with too many false positives will only lead to "garbage in garbage out" by Canopy. We are currently working on automating the pipeline for generating CNA and SNA input as well as offering guidance to select the informative CNAs. By saying informative, we mean that the SNAs or CNAs show distinct patterns between different samples (from the same patient since we are looking at intratumor heterogeneity). For SNAs, this means that the observed VAFs are different (see Figure 4B in our paper) and in this case a heatmap is a good way for visualization. For CNAs, this means that the WM and Wm are different (see Supplementary Figure S13 in our paper) and we find [IGV](http://software.broadinstitute.org/software/igv/) a good tool for visualization.
  
* What is matrix C?

  Matrix C is only needed if overlapping CNAs are used as input. If there is no overlapping CNA, C can be left as null. As an example from the vignettes below,
  
  |            |     chr7_1 |    chr7_2 |     chr12_1 |    chr12_2 | chr18 | chr19 |
  |------------|------------|-----------|-------------|------------|-------|-------|
  |        chr7|       1    |      1    |       0     |       0    |   0   |   0   |
  |       chr12|       0    |      0    |       1     |       1    |   0   |   0   |
  |       chr18|       0    |      0    |       0     |       0    |   1   |   0   |
  |       chr19|       0    |      0    |       0     |       0    |   0   |   1   |


