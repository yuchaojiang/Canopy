initialcnacopy = function(tree) {
    s.cna = nrow(tree$cna)
    cna.copy = matrix(nrow = 2, ncol = s.cna)
    colnames(cna.copy) = paste("cna", 1:s.cna, sep = "")
    for (j in 1:s.cna) {
        CM.temp = (0:3)[which(rmultinom(1, 1, c(0.1, 0.5, 0.3, 0.1))[, 
            1] == 1)]
        cna.copy[1, j] = CM.temp
        if (CM.temp <= 1) {
            cna.copy[2, j] = 0
        } else {
            cna.copy[2, j] = (0:CM.temp)[which(rmultinom(1, 1, rep(1/(CM.temp + 
                1), (CM.temp + 1)))[, 1] == 1)]
        }
    }
    rownames(cna.copy) = c("major_copy", "minor_copy")
    colnames(cna.copy) = rownames(tree$cna)
    return(cna.copy)
} 
