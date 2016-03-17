sortcna = function(tree, C) {
    cna.copy = tree$cna.copy
    for (i in which(apply(C, 1, sum) > 1)) {
        col.temp = which(C[i, ] == 1)
        if (cna.copy[1, col.temp[1]] < cna.copy[1, col.temp[2]]) {
            tree$cna.copy[, col.temp] = cna.copy[, rev(col.temp)]
            tree$cna[col.temp, 2:3] = tree$cna[rev(col.temp), 2:3]
            tree$Q[, col.temp] = tree$Q[, rev(col.temp)]
            tree$H[, col.temp] = tree$H[, rev(col.temp)]
        } else if (cna.copy[1, col.temp[1]] == cna.copy[1, col.temp[[2]]]) {
            if (cna.copy[2, col.temp[1]] < cna.copy[2, col.temp[2]]) {
                tree$cna.copy[, col.temp] = cna.copy[, rev(col.temp)]
                tree$cna[col.temp, 2:3] = tree$cna[rev(col.temp), 2:3]
                tree$Q[, col.temp] = tree$Q[, rev(col.temp)]
                tree$H[, col.temp] = tree$H[, rev(col.temp)]
            }
        }
    }
    tree$clonalmut = getclonalcomposition(tree)
    return(tree)
} 
