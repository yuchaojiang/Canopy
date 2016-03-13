sampP = function(tree, cell.line) {
    if (cell.line == TRUE) {
        P = tree$P
        colchange = sample.int(1, n = ncol(P))
        for (j in colchange) {
            rowchange = sample(2:nrow(P), 2)
            temp = sum(P[rowchange, j]) * 1000
            P[rowchange, j] = rmultinom(1, temp, prob = runif(length(rowchange), 
                0, 1))/1000
        }
        P = round(P, 3)
        if (ncol(P) == 1) {
            P[nrow(P), ] = 1 - colSums(as.matrix(P[1:(nrow(P) - 1), 
                ]))
        } else {
            P[nrow(P), ] = 1 - colSums(P[1:(nrow(P) - 1), ])
        }
    } else if (cell.line == FALSE) {
        P = tree$P
        colchange = sample.int(1, n = ncol(P))
        for (j in colchange) {
            rowchange = sample(1:nrow(P), 2)
            temp = sum(P[rowchange, j]) * 1000
            P[rowchange, j] = rmultinom(1, temp, prob = runif(length(rowchange), 
                0, 1))/1000
        }
        P = round(P, 3)
        if (ncol(P) == 1) {
            P[nrow(P), ] = 1 - colSums(as.matrix(P[1:(nrow(P) - 1), 
                ]))
        } else {
            P[nrow(P), ] = 1 - colSums(P[1:(nrow(P) - 1), ])
        }
    }
    return(P)
} 
