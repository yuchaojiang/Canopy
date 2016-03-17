initialP = function(tree, sampname, cell.line) {
    k = (nrow(tree$edge) + 2)/2
    n = length(sampname)
    if (cell.line == TRUE) {
        P = rbind(rep(0, n), rmultinom(n, 100, prob = rep(1/(k - 1), 
            (k - 1)))/100)
    } else if (cell.line == FALSE) {
        P = rmultinom(n, 100, prob = rep(1/k, k))/100
    }
    colnames(P) = sampname
    rownames(P) = paste("clone", 1:k, sep = "")
    return(P)
} 
