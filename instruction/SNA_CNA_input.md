## **How do I generate SNA input for Canopy?**

 * We use UnifiedGenotyper by **[GATK](https://software.broadinstitute.org/gatk/)** to call somatic SNAs and follow its [Best Practices](https://software.broadinstitute.org/gatk/best-practices/). A demo code can be found [here](https://github.com/yuchaojiang/Canopy/blob/master/instruction/UnifiedGenotyper.sh). **[MuTect](http://archive.broadinstitute.org/cancer/cga/mutect)** and **[VarScan2](http://massgenomics.org/varscan)** can also be used when paired normal samples are available.

 * *Stringent* QC procedures are strongly recommended. Just to list a few QCs that we have adopted:
    * Pass variant recalibration (VQSR) from GATK;
    * Have only one alternative allele (one locus being double hit by two different SNAs in one patient is very unlikely);
    * Are highly deleterious (i.e., focuse on driver mutations) from functional annotations (**[ANNOVAR](http://annovar.openbioinformatics.org/en/latest/)**);
    * Have low population variant frequency from the 1000 Genomes Project (if no normal samples are available);
    * Don't reside in segmental duplication regions;
    * Have high depth of coverage (total as well as mutated read depth);
    * Reside in target baits (e.g., exonic regions for exome sequencing);
    * ...
    * ...
      

 * After mutation calling and QC procedures, the number of mutated reads will be stored in matrix R while the total number of reads will be stored in matrix X across all mutational loci in all samples. An example data input of a leukemia patient AML43 from [Ding et al. (Nature 2012)](http://www.nature.com/nature/journal/v481/n7382/full/nature10738.html) can be found [here](https://github.com/yuchaojiang/Canopy/blob/master/instruction/AML43_DingEtAl.txt). Note: This study focused on SNAs in copy-neutral regions of the genome.
 
 * A good way for sanity check is to plot the variant allele frequencies (VAFs) across samples.
   * If there are only two samples, a 2-D scatterplot will suffice. In the figure below, the left panel contains the VAFs at two timepoints for the leukemia patient from [Ding et al. (Nature 2012)](http://www.nature.com/nature/journal/v481/n7382/full/nature10738.html). We see that there are clear clusters of mutations indicating they fall on the same branch of the tree, which serves as a nice sanity check of our mutation calling and filtering.
   * If there are more than two samples, heatmap can be used for visualization. The right panel in the figure below is the heatmap of VAFs across 63 somatic mutations in 10 spatially separated tumor slices of a ovarian cancer patient from [Bashashati et al. (The Journal of pathology 2013)](http://onlinelibrary.wiley.com/doi/10.1002/path.4230/abstract).

<p align="center">
  <img src='https://github.com/yuchaojiang/Canopy/blob/master/instruction/demo-page-001.jpg' width='500' height='500' >
</p>

## **How do I generate CNA input for Canopy?**
To generate allele-specific copy number calls, [Sequenza](https://cran.r-project.org/web/packages/sequenza/index.html) (see below) or [FALCON-X](https://cran.fhcrc.org/web/packages/falconx/index.html) (instructions to follow soon) can be used.

Sequenza estimates allele-specific copy numbers as well as tumor purity and ploidy using B-allele frequencies and depth ratios from paired tumor-normal sequencing data. Here are Sequenza outputs from WES of normal, primary tumor and relapse genome of a neuroblastoma patient from [Eleveld et al. (Nature Genetics 2015)](http://www.nature.com/ng/journal/v47/n8/abs/ng.3333.html).

   * [Primary tumor Sequenza segment output](https://github.com/yuchaojiang/Canopy/blob/master/instruction/primary.txt)
   * [Relapse genome Sequenza segment output](https://github.com/yuchaojiang/Canopy/blob/master/instruction/relapse.txt)

Data visualization and QC procedures on Sequenza's segmentation output are strongly recommended. Below is genome-wide view from Sequenza as a sanity check. The top panel is for the primary tumor and the bottom panel is for the relapse. The red and blue lines are for the major and minor copy numbers, respectively. We see that large chromosome-arm level deletions and duplications are fairly concordant between the primary tumor and the relapse genome (check!), while the relapse tumor gained additional CNAs at the second timepoint. The small CNA events, however, are most likely false positives and should be filtered out through QC procedures, which may include:
   * Have at least 100 heterozygous loci within each segment;
   * Are at least 5Mb long;
   * Don't have extreme estimated copy numbers (e.g., total copy number >= 6);
   * ...
   * ...
It is also worth noting that additional steps are needed to further curate the segments. For example, chr17q is split into three segments in the primary tumor, which should be just one large duplication instead (via comparison against the relapse). Furthermore, the breakpoints of the same CNA events between the primrary tumor and the relapse genome are sometimes different and they need to be merged.

<p align="center">
  <img src='https://github.com/yuchaojiang/Canopy/blob/master/instruction/primary.jpg' >
</p>
<p align="center">
  <img src='https://github.com/yuchaojiang/Canopy/blob/master/instruction/relapse.jpg' >
</p>

Canopy does not require interger allele-specific copy number as input. While Sequenza infers tumor purity and ploidy and outputs interger-valued allle-specifc copy numbers, Canopy directly takes as input the fractional allele-specific copy numbers, which can be obtained from the segmentation output (see above). The B-allele frequency is Bf = Wm / (WM + Wm) and the depth ratio is depth.ratio = (WM + Wm)/2. From here the input matrix WM and Wm can be calculated. The standard errors of the estimated copy numbers, epsilonM and epsilonm, can be set as default by Canopy or be taken as the sd.ratio from Sequenza's output, assuming they are the same.
    
    
## **Which CNAs and SNAs should I use?**
  
  How to generate a clean set of input to Canopy is important and non-trivial. While in our phylogeney reconstruction paper we were not trying to solve this tricky but separate problem of quality control of point mutation profiling and copy number estimation, an input with too many false positives will only lead to "garbage in garbage out" by Canopy. We are currently working on automating the pipeline for generating CNA and SNA input as well as offering guidance to select the ***informative*** SNAs and CNAs. By saying ***informative***, we mean that the SNAs or CNAs show distinct patterns between different samples (from the same patient since we are looking at intratumor heterogeneity). For SNAs, this means that the observed VAFs are different (see Figure 4B in our paper) and in this case a heatmap is a good way for visualization. For CNAs, this means that the WM and Wm are different (see Supplementary Figure S13 in our paper) and we find **[IGV](http://software.broadinstitute.org/software/igv/)** a good tool for visualization and recommend focusing on large CNA regions, which helps remove false calls and speed up computation.
  
  Just like SNAs, there will likely to be CNAs carried by small fractions of the cells, or that reside in hard-to-call regions of the genome, which are not detected. The former scenario, in particular, includes CNAs which may be informative about rare subclones. We do not assume that the CNAs (and SNAs) given to Canopy comprise all mutations that are carried by the sample, and similarly, do not attempt to claim that Canopy detects all subclones or resolves all branches of the evolutionary tree. Our goal is only to estimate all of the subclones that have representation among the set of input CNAs and SNAs, which are, inherently, limited in resolution by the experimental protocol (sequencing platform and coverage, number of tumor slices, etc.) We believe this is the best that can be achieved under current settings.
