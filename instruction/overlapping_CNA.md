* What is matrix C? How do I deal with overlapping CNAs?

  Matrix C is only needed if overlapping CNAs are used as input -- if there is no overlapping CNA, C can be left as null. If there are overlapping CNA events, the columns of the C matrix are the CNA ***events*** and the rows are the CNA ***regions***.
  
  As an example from the vignettes below, we know from the profiled CNAs (ses Supplementary Figure S13) in our paper that two CNA events hit the same BRAF region on chr7 and that two CNA events hit the same KRAS region on chr12. There are altogether four CNA regions and six CNA events. The C matrix specifies whether CNA regions harbor specific CNA events. In the case of overlapping CNAs, manual inspection is needed to identify mixture of CNA events with different copy number changes or different breakpoints.
  
  |            |     chr7_1 |    chr7_2 |     chr12_1 |    chr12_2 | chr18 | chr19 |
  |------------|------------|-----------|-------------|------------|-------|-------|
  |        chr7|       1    |      1    |       0     |       0    |   0   |   0   |
  |       chr12|       0    |      0    |       1     |       1    |   0   |   0   |
  |       chr18|       0    |      0    |       0     |       0    |   1   |   0   |
  |       chr19|       0    |      0    |       0     |       0    |   0   |   1   |


