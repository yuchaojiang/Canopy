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
    # SNA
    sna.read = R
    reference.read = X - R
    sna.freq = tree$VAF
    sna.freq[sna.freq <= 0] = 1e-04
    sna.freq[sna.freq >= 1] = 0.9999
    l=sum(sna.read*log(sna.freq)+reference.read*log(1-sna.freq))
    # CNA
    CM.sample = tree$CM %*% tree$P
    Cm.sample = tree$Cm %*% tree$P
    l = l + sum(dnorm(WM, mean=CM.sample, sd = epsilonM, log = TRUE))
    l = l + sum(dnorm(Wm, mean=Cm.sample, sd = epsilonm, log = TRUE))
    return(l)
} 
