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
      

 * A good way for sanity check is to plot the variant allele frequencies (VAFs) across samples. If there are only two samples, a 2-D scatterplot will suffice; if there are more than two samples, heatmap can be used for visualization.

 
## **How do I generate CNA input for Canopy?**
To generate allele-specific copy number calls, [Sequenza](https://cran.r-project.org/web/packages/sequenza/index.html) (see below) or [FALCON-X](https://cran.fhcrc.org/web/packages/falconx/index.html) (instructions to follow soon) can be used.

Below is output of chr11 from Sequenza.

![sequenza_seg] (https://github.com/yuchaojiang/Canopy/blob/master/instruction/sequenza_seg.png)

![sequenza_view] (https://github.com/yuchaojiang/Canopy/blob/master/instruction/sequenza_view.png)

The B-allele frequency is Bf = Wm / (WM + Wm) and the depth ratio is depth.ratio = (WM + Wm)/2. From here the input matrix WM and Wm can be calculated.
    
    
## **Which CNAs and SNAs should I use?**
  
  How to generate a clean set of input to Canopy is important and non-trivial. While in our phylogeney reconstruction paper we were not trying to solve this tricky but separate problem of quality control of copy number calls, an input with too many false positives will only lead to "garbage in garbage out" by Canopy. We are currently working on automating the pipeline for generating CNA and SNA input as well as offering guidance to select the ***informative*** SNAs and CNAs. By saying ***informative***, we mean that the SNAs or CNAs show distinct patterns between different samples (from the same patient since we are looking at intratumor heterogeneity). For SNAs, this means that the observed VAFs are different (see Figure 4B in our paper) and in this case a heatmap is a good way for visualization. For CNAs, this means that the WM and Wm are different (see Supplementary Figure S13 in our paper) and we find **[IGV](http://software.broadinstitute.org/software/igv/)** a good tool for visualization and recommend focusing on large CNA regions, which helps remove false calls and speed up computation.
  
  Just like SNAs, there will likely to be CNAs carried by small fractions of the cells, or that reside in hard-to-call regions of the genome, which are not detected. The former scenario, in particular, includes CNAs which may be informative about rare subclones. We do not assume that the CNAs (and SNAs) given to Canopy comprise all mutations that are carried by the sample, and similarly, do not attempt to claim that Canopy detects all subclones or resolves all branches of the evolutionary tree. Our goal is only to estimate all of the subclones that have representation among the set of input CNAs and SNAs, which are, inherently, limited in resolution by the experimental protocol (sequencing platform and coverage, number of tumor slices, etc.) We believe this is the best that can be achieved under current settings.
