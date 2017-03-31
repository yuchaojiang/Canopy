## **Binomial clustering on SNAs**
  
  A multivariate binomial mixture clustering step can be applied to the SNAs before MCMC sampling. We show in our paper via simulations that this pre-clustering method helps the Markov chain converge faster with smaller estimation error (especially when mutations show clear cluster patterns by visualization).
  
  I'm in the process of integrating this part into the R package. For now, the code can be found at **[binomial_EM.R](https://github.com/yuchaojiang/Canopy/blob/master/clustering/binomial_EM.R).** All R functions and datasets for illustration purpose are in this same folder. Detailed methods can be found in the [supplements](http://www.pnas.org/content/suppl/2016/08/26/1522203113.DCSupplemental/pnas.1522203113.sapp.pdf) of our paper under section Binomial mixture clustering. BIC is used for model selection. 2D (two longitudinal/spatial samples) or 3D (three samples) plots are generated for visualization.
  
  
  This clustering step can also remove likely false positives before feeding the mutations to the MCMC algorithm.
  
