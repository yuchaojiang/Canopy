getlikelihood.sna = function(tree, R, X) {
    # SNA
    sna.read = R
    reference.read = X - R
    sna.freq = tree$VAF
    sna.freq[sna.freq <= 0] = 1e-04
    sna.freq[sna.freq >= 1] = 0.9999
    l=sum(sna.read*log(sna.freq)+reference.read*log(1-sna.freq))
    return(l)
} 
