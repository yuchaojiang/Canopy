getclonalcomposition = function(tree) {
    snaname = rownames(tree$sna)
    cnaname = rownames(tree$cna)
    n = (nrow(tree$edge) + 2)/2
    clonal.mutations = vector("list", n)
    for (tip in 2:n) {
        child.node = tip
        parent.node = tree$edge[which(tree$edge[, 2] == child.node), 
            1]
        while (parent.node >= (n + 1)) {
            muttemp = snaname[intersect(which(tree$sna[, 2] == parent.node), 
                which(tree$sna[, 3] == child.node))]
            if (length(muttemp) > 0) {
                clonal.mutations[[tip]] = c(clonal.mutations[[tip]], 
                  muttemp)
            }
            child.node = parent.node
            if (child.node == (n + 1)) 
                break
            parent.node = tree$edge[which(tree$edge[, 2] == child.node), 
                1]
        }
    }
    
    for (tip in 2:n) {
        child.node = tip
        parent.node = tree$edge[which(tree$edge[, 2] == child.node), 
            1]
        while (parent.node >= (n + 1)) {
            muttemp = cnaname[intersect(which(tree$cna[, 2] == parent.node), 
                which(tree$cna[, 3] == child.node))]
            if (length(muttemp) > 0) {
                clonal.mutations[[tip]] = c(clonal.mutations[[tip]], 
                  muttemp)
            }
            child.node = parent.node
            if (child.node == (n + 1)) 
                break
            parent.node = tree$edge[which(tree$edge[, 2] == child.node), 
                1]
        }
    }
    
    clonal.mutations[[1]] = "None"
    for (k in 1:length(clonal.mutations)) {
        if (!is.null(clonal.mutations[[k]]) & (length(clonal.mutations[[k]])) > 
            0) {
            clonal.mutations[[k]] = sort(clonal.mutations[[k]])
        }
    }
    return(clonal.mutations)
} 
