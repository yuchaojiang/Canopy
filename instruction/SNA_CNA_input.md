* **How do I generate SNA input for Canopy?**
  
  We use UnifiedGenotyper by **[GATK](https://software.broadinstitute.org/gatk/)** to call somatic SNAs and follow its [Best Practices](https://software.broadinstitute.org/gatk/best-practices/). A demo code can be found [here](https://github.com/yuchaojiang/Canopy/blob/master/instruction/UnifiedGenotyper.sh). **[MuTect](http://archive.broadinstitute.org/cancer/cga/mutect)** can also be used when paired normal samples are available.
  
  Stringent QC procedures are strongly recommended.
 * Focus on highly deleterious mutations from functional annotations, which have a higher chance to be driver mutations;
 * Filter out mutations with low depth of coverage (total as well as mutated read depth);


* **How do I generate CNA input for Canopy?**
  
  To generate allele-specific copy number calls, [Sequenza](https://cran.r-project.org/web/packages/sequenza/index.html) (see below) or [FALCON-X](https://cran.fhcrc.org/web/packages/falconx/index.html) (instructions to follow soon) can be used.
  
    Below is output of chr11 from Sequenza. 
  
    ![sequenza_seg] (https://github.com/yuchaojiang/Canopy/blob/master/instruction/sequenza_seg.png)
  
    ![sequenza_view] (https://github.com/yuchaojiang/Canopy/blob/master/instruction/sequenza_view.png)
  
    The B-allele frequency is Bf = Wm / (WM + Wm) and the depth ratio is depth.ratio = (WM + Wm)/2. From here the input matrix WM and Wm can be calculated.
