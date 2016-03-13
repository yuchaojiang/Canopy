canopy.BIC = function(sampchain, projectname, K, numchain, burnin, thin, 
    pdf = NULL) {
    if (is.null(pdf)) {
        pdf = TRUE
    }
    lik.k = rep(NA, length(K))
    BIC = rep(NA, length(K))
    ki = 1
    for (k in K) {
        sampchaink = sampchain[[ki]]
        temp.tree = sampchaink[[1]][[1]]
        s = nrow(temp.tree$VAF)
        n = ncol(temp.tree$VAF)
        t = ncol(temp.tree$Q)
        numchain = length(sampchaink)
        # burn-in
        samptreenew = sampchaink[[1]][(burnin + 1):length(sampchaink[[1]])]
        numpostburn = length(samptreenew)
        # thinning
        temp <- thin * c(1:(numpostburn/thin))
        samptreethin = samptreenew[temp]
        length(samptreethin)
        for (numi in 2:numchain) {
            samptreenew = sampchaink[[numi]][(burnin + 1):
                                               length(sampchaink[[numi]])]
            numpostburn = length(samptreenew)
            temp <- thin * c(1:(numpostburn/thin))
            samptreethin = c(samptreethin, samptreenew[temp])
        }
        samptreelik = rep(NA, length(samptreethin))
        for (treei in 1:length(samptreethin)) {
            samptreelik[treei] = samptreethin[[treei]]$likelihood
        }
        samptreethin = samptreethin[which((rank(-1 * samptreelik,
            ties.method = "first")) < (length(samptreethin)/numchain))]
        samptreelik = rep(NA, length(samptreethin))
        for (treei in 1:length(samptreethin)) {
            samptreelik[treei] = samptreethin[[treei]]$likelihood
        }
        lik.temp = mean(samptreelik)
        cat("k =", k, ": mean likelihood", lik.temp, ".\n")
        K.data = 2 * (2 * k - 3) + 2 * t + s + (k - 1) * n
        N = s * n * 2 + t * n * 4 + s
        BIC.temp = 2 * lik.temp - K.data * log(N)
        lik.k[ki] = lik.temp
        BIC[ki] = BIC.temp
        ki = ki + 1
    }
    if (pdf) {
        pdf(file = paste(projectname, "_BIC.pdf", sep = ""), height = 5, 
            width = 5)
    }
    plot(K, BIC, xlab = "Number of subclones", ylab = "BIC", type = "b", 
        xaxt = "n")
    axis(1, at = K)
    abline(v = K[which.max(BIC)], lty = 2)
    title(paste("BIC for model selection", projectname))
    if (pdf) {
        dev.off()
    }
    return(BIC)
} 
