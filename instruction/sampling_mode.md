## **What if I only have SNA input? What are the sampling modes for Canopy?**
  
  There are four modes of MCMC sampling embedded in Canopy. If only SNAs are used as input, **canopy.sample.cluster.nocna** should be used if pre-clustering is adopted on the SNAs (recommended if there is a large number of SNAs and they form clusters by visual inspection, i.e., heatmap of the VAF matrix); **canopy.sample.nocna** should be used if no pre-clustering step is adopted. SNAs with VAFs greater than 50% should be removed (from CNA regions, the data input of which is not provided). Furthermore, from our experience, multiple tree configurations exist if only SNAs are used as input and thus it is recommended to increase the number of chains in the MCMC sampling step so that as much tree space as possible will be sampled.
  
  (1) **canopy.sample**, which takes both SNA and CNA as input by default:
```r
library(Canopy)
data("MDA231")
projectname = MDA231$projectname ## name of project
R = MDA231$R; R ## mutant allele read depth (for SNAs)
X = MDA231$X; X ## total depth (for SNAs)
WM = MDA231$WM; WM ## observed major copy number (for CNA regions)
Wm = MDA231$Wm; Wm ## observed minor copy number (for CNA regions)
epsilonM = MDA231$epsilonM ## standard deviation of WM, pre-fixed here
epsilonm = MDA231$epsilonm ## standard deviation of Wm, pre-fixed here
## whether CNA regions harbor specific CNAs (only needed for overlapping CNAs)
C = MDA231$C; C
Y = MDA231$Y; Y ## whether SNAs are affected by CNAs

K = 3:5 # number of subclones
numchain = 15 # number of chains with random initiations
sampchain = canopy.sample(R = R, X = X, WM = WM, Wm = Wm, epsilonM = epsilonM, 
                          epsilonm = epsilonm, C = C, Y = Y, K = K, 
                          numchain = numchain, max.simrun = 100000,
                          min.simrun = 20000, writeskip = 200,
                          projectname = projectname, cell.line = TRUE,
                          plot.likelihood = TRUE)
  ```
  
  (2) **canopy.sample.nocna** for cases where there is no CNA input:
```r
sampchain = canopy.sample.nocna(R = R, X = X,
                                        K = K, numchain = numchain, 
                                        max.simrun = 100000, min.simrun = 20000,
                                        writeskip = 200, projectname = projectname,
                                        cell.line = FALSE, plot.likelihood = TRUE)
```  
  
  (3) **canopy.sample.cluster** for cases where SNAs are pre-clustered:
```r
sampchain = canopy.sample.cluster(R = R, X = X, sna_cluster = sna_cluster, 
                          WM = WM, Wm = Wm, epsilonM = epsilonM, 
                          epsilonm = epsilonm, C = C, Y = Y, K = K, 
                          numchain = numchain, max.simrun = 100000,
                          min.simrun = 20000, writeskip = 200,
                          projectname = projectname, cell.line = TRUE,
                          plot.likelihood = TRUE)
```
  
  (4) **canopy.sample.cluster.nocna** for cases where there is no CNA input and SNAs are pre-clustered:
```r
library(Canopy)
data(toy3)
R=toy3$R; X=toy3$X
num_cluster=2:9 # Range of number of clusters to run
num_run=10 # How many EM runs per clustering step for each mutation cluster wave
canopy.cluster=canopy.cluster(R = R, X = X,
                              num_cluster = num_cluster, num_run = num_run)
# BIC to determine the optimal number of mutation clusters
bic_output=canopy.cluster$bic_output
Mu=canopy.cluster$Mu # VAF centroid for each cluster
Tau=canopy.cluster$Tau  # Prior for mutation cluster, with a K+1 component
sna_cluster=canopy.cluster$sna_cluster # cluster identity for each mutation
projectname='toy3'
K = 3:5 # number of subclones
numchain = 15 # number of chains with random initiations
sampchain = canopy.sample.cluster.nocna(R = R, X = X, sna_cluster = sna_cluster,
                                        K = K, numchain = numchain, 
                                        max.simrun = 100000, min.simrun = 20000,
                                        writeskip = 200, projectname = projectname,
                                        cell.line = FALSE, plot.likelihood = TRUE)
```
