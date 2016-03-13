sampcna = function(tree) {
    t = nrow(tree$cna)
    cna = tree$cna
    cna.change = sample.int(sample.int(1, n = t), n = t)
    cna.edge = sample(2:nrow(tree$edge), size = length(cna.change), 
        replace = TRUE)
    cna[cna.change, 2] = tree$edge[cna.edge, 1]
    cna[cna.change, 3] = tree$edge[cna.edge, 2]
    return(cna)
} 
