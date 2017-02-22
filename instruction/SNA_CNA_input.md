* **How do I generate SNA input for Canopy?**
  
 * We use UnifiedGenotyper by **[GATK](https://software.broadinstitute.org/gatk/)** to call somatic SNAs and follow its [Best Practices](https://software.broadinstitute.org/gatk/best-practices/). A demo code can be found [here](https://github.com/yuchaojiang/Canopy/blob/master/instruction/UnifiedGenotyper.sh). **[MuTect](http://archive.broadinstitute.org/cancer/cga/mutect)** can also be used when paired normal samples are available.
  
 * Stringent QC procedures are strongly recommended.
  - Pass variant recalibration (VQSR) from GATK;
 * Have only one alternative allele (one locus being double hit by two different SNAs in one patient is very unlikely);
 * Are highly deleterious from functional annotations, which have a higher chance to be driver mutations;
 * Have high depth of coverage (total as well as mutated read depth);
 
 A good way for sanity check is to plot the variant allele frequencies (VAFs) across samples. If there are only two samples, a 2-D scatterplot will suffice; if there are more than two samples, heatmap can be used for visualization.
 
 After visualization confirms that there are clusters in the SNA data, a bivariate clustering step can be applied to pre-cluster mutations before MCMC starts sampling.
 


* **How do I generate CNA input for Canopy?**
  
  To generate allele-specific copy number calls, [Sequenza](https://cran.r-project.org/web/packages/sequenza/index.html) (see below) or [FALCON-X](https://cran.fhcrc.org/web/packages/falconx/index.html) (instructions to follow soon) can be used.
  
    Below is output of chr11 from Sequenza. 
  
    ![sequenza_seg] (https://github.com/yuchaojiang/Canopy/blob/master/instruction/sequenza_seg.png)
  
    ![sequenza_view] (https://github.com/yuchaojiang/Canopy/blob/master/instruction/sequenza_view.png)
  
    The B-allele frequency is Bf = Wm / (WM + Wm) and the depth ratio is depth.ratio = (WM + Wm)/2. From here the input matrix WM and Wm can be calculated.
