sampcnacopy = function(tree) {
    t = nrow(tree$cna)
    cna.change = sample.int(1, n = t)
    cna.copy = tree$cna.copy
    CM.temp = (0:3)[which(rmultinom(1, 1, c(0.1, 0.5, 0.3, 0.1))[, 1] == 
        1)]
    cna.copy[1, cna.change] = CM.temp
    if (CM.temp <= 1) {
        cna.copy[2, cna.change] = 0
    } else {
        cna.copy[2, cna.change] = (0:CM.temp)[which(rmultinom(1, 1, 
            rep(1/(CM.temp + 1), (CM.temp + 1)))[, 1] == 1)]
    }
    return(cna.copy)
} 
