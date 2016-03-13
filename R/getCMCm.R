getCMCm = function(tree, C) {
    k = (nrow(tree$edge) + 2)/2
    s.cna = nrow(C)
    CM = matrix(nrow = s.cna, ncol = k, data = 1)
    rownames(CM) = rownames(C)
    colnames(CM) = paste("clone", 1:k, sep = "")
    Cm = CM
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
    for (i in 1:nrow(C)) {
        cnai = which(C[i, ] == 1)
        cnai = cnai[rank(tree$cna[cnai, 2], ties.method = "random")]
        for (s in cnai) {
            for (t in 2:k) {
                if (is.element(s, clonal.cna[[t]])) {
                  CM[i, t] = tree$cna.copy[1, s]
                  Cm[i, t] = tree$cna.copy[2, s]
                }
            }
        }
    }
    return(list(CM, Cm))
} 
