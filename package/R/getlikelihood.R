getlikelihood = function(tree, R, X, WM, Wm, epsilonM, epsilonm) {
    if ((!is.matrix(epsilonM)) & length(epsilonM == 1)) {
        epsilonM = matrix(ncol = ncol(WM), nrow = nrow(WM), data = epsilonM)
        colnames(epsilonM) = colnames(WM)
        rownames(epsilonM) = rownames(WM)
    }
    if ((!is.matrix(epsilonm)) & length(epsilonm == 1)) {
        epsilonm = matrix(ncol = ncol(WM), nrow = nrow(WM), data = epsilonm)
        colnames(epsilonm) = colnames(WM)
        rownames(epsilonm) = rownames(WM)
    }
    l = 0
    # SNA
    sna.read = R
    reference.read = X - R
    sna.freq = tree$VAF
    sna.freq[sna.freq <= 0] = 1e-04
    sna.freq[sna.freq >= 1] = 0.9999
    for (muti in 1:length(sna.read)) {
        l = l + sna.read[muti] * log(sna.freq[muti]) + reference.read[muti] * 
            log(1 - sna.freq[muti])
    }
    # CNA
    CM.sample = tree$CM %*% tree$P
    Cm.sample = tree$Cm %*% tree$P
    for (cnai in 1:length(CM.sample)) {
        l = l + dnorm(WM[cnai], mean = CM.sample[cnai], sd = epsilonM[cnai], 
            log = TRUE)
        l = l + dnorm(Wm[cnai], mean = Cm.sample[cnai], sd = epsilonm[cnai], 
            log = TRUE)
    }
    return(l)
} 
