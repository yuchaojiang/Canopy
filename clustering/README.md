## **Binomial clustering on SNAs**
  
  A multivariate binomial mixture clustering step can be applied to the SNAs before MCMC sampling. We show in our paper via simulations that this pre-clustering method helps the Markov chain converge faster with smaller estimation error (especially when mutations show clear cluster patterns by visualization). This clustering step can also remove likely false positives before feeding the mutations to the MCMC algorithm.
  
  I'm in the process of integrating this part into the R package. For now, code for clustering can be found at **[binomial_EM.R](https://github.com/yuchaojiang/Canopy/blob/master/clustering/binomial_EM.R).** All R functions and datasets for illustration purpose are in **[this same folder](https://github.com/yuchaojiang/Canopy/edit/master/clustering)**. Detailed methods can be found in the **[supplements](http://www.pnas.org/content/suppl/2016/08/26/1522203113.DCSupplemental/pnas.1522203113.sapp.pdf)** of our paper under section *Binomial mixture clustering*. BIC is used for model selection. 2D (two longitudinal/spatial samples) or 3D (three samples) plots are generated for visualization.
  
  Below is a toy example I generated from a tree of 4 clones/leaves. The 5 branches of the tree (excluding the leftmost branch, which corresponds to the normal clone) separate 200 in silico mutations into 5 mutation clusters.

<p align="center">
  <img src='https://github.com/yuchaojiang/Canopy/blob/master/clustering/sim_toy_BIC.jpg' width='300' height='300' >
</p>

<p align="center">
  <img src='https://github.com/yuchaojiang/Canopy/blob/master/clustering/sim_toy_classification.jpg' width='500' height='500' >
</p>
  
<p align="center">
  <img src='https://github.com/yuchaojiang/Canopy/blob/master/clustering/AML43_classification.jpg' width='500' height='500' >
</p>


  Canopy then uses the pre-clustering results to initialize the MCMC procedure, and then fine tunes the individual mutations (each SNA and each CAN) within each cluster later in the MCMC run. This part is to be updated on April 1st.
