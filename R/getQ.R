getQ = function(tree, Y, C) {
    Q = Y[, -1] %*% C  # whether SNAs precede CNAs
    for (i in 1:nrow(Q)) {
        for (j in 1:ncol(Q)) {
            if (Q[i, j] == 1) {
                if (tree$sna[i, 2] > tree$cna[j, 2]) {
                  Q[i, j] = 0
                }
            }
        }
    }
    return(Q)
} 
