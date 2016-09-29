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
  
  The B-allele frequency is $Bf = W_m / (W_M + W_m)$ and the depth ratio is $depth.ratio = (W_M + W_m)/2$. From here the input matrix $W_M$ and $W_m$ can be calculated.

* Which CNAs and SNAs should I use?

* What is matrix C?




