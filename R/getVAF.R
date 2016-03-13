getVAF = function(tree, Y) {
    k = ncol(tree$CM)
    temp1 = Y %*% (rbind(rep(1, k), tree$CM))
    temp2 = Y %*% (rbind(rep(1, k), tree$Cm))
    denominator = (temp1 + temp2) %*% tree$P
    denominator[denominator < 0.001] = 0.001
    CZ = getCZ(tree)
    
    temp = tree$Z
    temp[1:length(temp)] = NA
    for (i in 1:nrow(temp)) {
        # ith SNP jth clone
        for (j in 1:ncol(temp)) {
            if (tree$Z[i, j] == 0) {
                temp[i, j] = 0
            } else {
                temp[i, j] = 1
                q.temp = which(tree$Q[i, ] == 1)
                if (length(q.temp) > 0) {
                  # sort from root to leaves
                  q.temp = q.temp[rank(tree$cna[q.temp, 2],
                                       ties.method = "random")]
                  for (s in q.temp) {
                    # sth CNA ith SNA from major copy of sth CNA
                    if (tree$H[i, s] == 1) {
                      if (CZ[s, j] == 1) {
                        temp[i, j] = (tree$cna.copy[1, s])
                      }
                    } else {
                      # ith SNA from minor copy of sth CNA
                      if (CZ[s, j] == 1) {
                        temp[i, j] = tree$cna.copy[2, s]^(CZ[s, j])
                      }
                    }
                  }
                }
            }
        }
    }
    numerator = temp %*% tree$P
    VAF = round(numerator/denominator, 3)
    return(VAF)
} 
