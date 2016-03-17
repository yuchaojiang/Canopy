getCZ = function(tree) {
    k = (nrow(tree$edge) + 2)/2
    t = nrow(tree$cna)
    CZ = matrix(nrow = t, ncol = k, data = 0)
    rownames(CZ) = rownames(tree$cna)
    colnames(CZ) = paste("clone", 1:k, sep = "")
    clonal.cna = vector("list", k)
    for (tip in 2:k) {
        child.node = tip
        parent.node = tree$edge[which(tree$edge[, 2] == child.node), 
            1]
        while (parent.node >= (k + 1)) {
            cnatemp = intersect(which(tree$cna[, 2] == parent.node), 
                which(tree$cna[, 3] == child.node))
            if (length(cnatemp) > 0) {
                clonal.cna[[tip]] = c(clonal.cna[[tip]], cnatemp)
            }
            child.node = parent.node
            if (child.node == (k + 1)) 
                break
            parent.node = tree$edge[which(tree$edge[, 2] == child.node), 
                1]
        }
    }
    clonal.cna[[1]] = 0
    for (k in 2:k) {
        for (t in 1:t) {
            if (is.element(t, clonal.cna[[k]])) {
                CZ[t, k] = 1
            }
        }
    }
    return(CZ)
} 
