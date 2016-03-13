getZ = function(tree, sna.name) {
    k = (nrow(tree$edge) + 2)/2
    s = nrow(tree$sna)
    Z = matrix(nrow = s, ncol = k, data = 0)
    rownames(Z) = sna.name
    colnames(Z) = paste("clone", 1:k, sep = "")
    clonal.sna = vector("list", k)
    for (tip in 2:k) {
        child.node = tip
        parent.node = tree$edge[which(tree$edge[, 2] == child.node), 
            1]
        while (parent.node >= (k + 1)) {
            snatemp = intersect(which(tree$sna[, 2] == parent.node), 
                which(tree$sna[, 3] == child.node))
            if (length(snatemp) > 0) {
                clonal.sna[[tip]] = c(clonal.sna[[tip]], snatemp)
            }
            child.node = parent.node
            if (child.node == (k + 1)) 
                break
            parent.node = tree$edge[which(tree$edge[, 2] == child.node), 
                1]
        }
    }
    clonal.sna[[1]] = 0
    for (k in 2:k) {
        for (s in 1:s) {
            if (is.element(s, clonal.sna[[k]])) {
                Z[s, k] = 1
            }
        }
    }
    return(Z)
} 
