canopy.post = function(sampchain, projectname, K, numchain, burnin, 
    thin, optK, C = NULL, post.config.cutoff = NULL) {
    if (is.null(C)) {
      C = diag(nrow(sampchain[[1]][[1]][[1]]$cna))
      colnames(C) = rownames(C) = rownames(sampchain[[1]][[1]][[1]]$cna)
    }
    if (is.null(post.config.cutoff)) {
        post.config.cutoff = 0.05
    }
    if (post.config.cutoff > 1 | post.config.cutoff <= 0) {
        stop("post.config.cutoff has to be between 0 and 1!")
    }
    sampchaink = sampchain[[which(K == optK)]]
    numchain = length(sampchaink)
    # burn-in
    samptreenew = sampchaink[[1]][(burnin + 1):length(sampchaink[[1]])]
    numpostburn = length(samptreenew)
    # thinning
    temp <- thin * c(1:(numpostburn/thin))
    samptreethin = samptreenew[temp]
    length(samptreethin)
    for (numi in 2:numchain) {
        samptreenew = sampchaink[[numi]][(burnin + 1):length(sampchaink[[numi]])]
        numpostburn = length(samptreenew)
        temp <- thin * c(1:(numpostburn/thin))
        samptreethin = c(samptreethin, samptreenew[temp])
    }
    samptreethin.lik = rep(NA, length(samptreethin))
    for (treei in 1:length(samptreethin)) {
        samptreethin.lik[treei] = samptreethin[[treei]]$likelihood
    }
    samptreethin = samptreethin[which((rank(-1 * samptreethin.lik, ties.method = "first")) < 
        (length(samptreethin)/numchain))]
    samptreethin.lik = rep(NA, length(samptreethin))
    for (treei in 1:length(samptreethin)) {
        samptreethin.lik[treei] = samptreethin[[treei]]$likelihood
    }
    
    for (i in 1:length(samptreethin)) {
        samptreethin[[i]] = sortcna(samptreethin[[i]], C)
    }
    
    for (i in 1:length(samptreethin)) {
        samptreethin[[i]]$clonalmut = getclonalcomposition(samptreethin[[i]])
    }
    config = rep(NA, length(samptreethin))
    config[1] = 1
    categ = 1
    for (i in 2:length(samptreethin)) {
        for (categi in 1:categ) {
            if ((sum(samptreethin[[i]]$clonalmut %in% samptreethin[[which(config == 
                categi)[1]]]$clonalmut)) == optK) {
                config[i] = categi
            }
        }
        if (is.na(config[i])) {
            config[i] = categ + 1
            categ = categ + 1
        }
    }
    config.summary = matrix(nrow = length(unique(config)), ncol = 3)
    colnames(config.summary) = c("Configuration", "Post_prob", "Mean_post_lik")
    config.summary[, 1] = unique(config)
    for (i in 1:nrow(config.summary)) {
        configi = config.summary[i, 1]
        configi.temp = which(config == configi)
        config.summary[i, 2] = round(length(configi.temp)/length(config), 
            3)
        config.summary[i, 3] = round(mean(samptreethin.lik[configi]), 
            2)
    }
    
    minor.config = which(config.summary[, 2] < post.config.cutoff)
    if (length(minor.config) > 0) {
        config.sel = rep(TRUE, length(config))
        for (i in minor.config) {
            config.sel[which(config == i)] = FALSE
        }
        samptreethin = samptreethin[config.sel]
        samptreethin.lik = samptreethin.lik[config.sel]
        config = config[config.sel]
        config.summary = config.summary[-minor.config, ]
        for (i in 1:nrow(config.summary)) {
            config[which(config == config.summary[i, 1])] = i
        }
        config.summary[, 1] = 1:nrow(config.summary)
        config.summary[, 2] = round(config.summary[, 2]/sum(config.summary[, 
            2]), 3)
    }
    return(list(samptreethin, samptreethin.lik, config, config.summary))
} 
