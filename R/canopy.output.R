canopy.output = function(post, config.i, C = NULL) {
    samptreethin = post[[1]]
    samptreethin.lik = post[[2]]
    config = post[[3]]
    config.summary = post[[4]]
    if (is.null(C)) {
      C = diag(nrow(samptreethin[[1]]$cna))
      colnames(C) = rownames(C) = rownames(samptreethin[[1]]$cna)
    }
    tree.loc = which(config == config.i)
    output.tree = samptreethin[[tree.loc[which.max(samptreethin.lik[tree.loc])]]]
    # change cna names based on their inferred major and minor copy
    # numbers
    cnacopy.temp = output.tree$cna.copy
    cna.newname = rep(NA, ncol(cnacopy.temp))
    for (j in 1:ncol(cnacopy.temp)) {
        if (cnacopy.temp[2, j] == 0 & cnacopy.temp[1, j] <= 1) {
            cna.newname[j] = paste((rownames(C))[which(C[, j] == 1)], 
                "_del", sep = "")
        } else if (cnacopy.temp[2, j] == 0 & cnacopy.temp[1, j] > 1) {
            cna.newname[j] = paste((rownames(C))[which(C[, j] == 1)], 
                "_LOH", sep = "")
        } else if (cnacopy.temp[2, j] >= 1) {
            cna.newname[j] = paste((rownames(C))[which(C[, j] == 1)], 
                "_dup", sep = "")
        }
    }
    rownames(output.tree$cna) = colnames(output.tree$cna.copy) = colnames(output.tree$Q) = colnames(output.tree$H) = cna.newname
    output.tree$clonalmut = getclonalcomposition(output.tree)
    return(output.tree)
} 
