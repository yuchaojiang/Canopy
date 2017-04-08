## **What if I only have SNA input? What are the sampling modes for Canopy?**
  
  There are four modes of MCMC sampling embedded in Canopy.
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
  
  
  (3) **canopy.sample.cluster** for cases where SNAs are pre-clustered:
  
  
  (4) **canopy.sample.cluster** for cases where there is no CNA input and SNAs are pre-clustered:
