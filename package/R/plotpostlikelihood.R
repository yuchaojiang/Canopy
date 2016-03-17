plotpostlikelihood = function(sampchaink, projectname, k, numchain) {
    # plot log-likelihood for each chain
    pdf(file = paste(projectname, "_likelihood_", k, ".pdf", sep = ""), 
        width = 8, height = 6)
    clikelihood = matrix(nrow = numchain, ncol = length(sampchaink[[1]]), 
        data = NA)
    for (numi in 1:numchain) {
        for (i in 1:ncol(clikelihood)) {
            clikelihood[numi, i] = sampchaink[[numi]][[i]]$likelihood
        }
    }
    plot(1:ncol(clikelihood), clikelihood[1, ], type = "l", xlab = "Iteration", 
        ylab = "Log-likelihood", col = 1, ylim = c(min(clikelihood), 
            max(clikelihood)))
    for (numi in 2:numchain) {
        points(1:ncol(clikelihood), clikelihood[numi, ], type = "l", 
            col = numi)
    }
    title(paste("Posterior likelihood", projectname, k, "subclones", 
        numchain, "chains"))
    dev.off()
} 
