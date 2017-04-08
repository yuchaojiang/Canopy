sampsna = function(tree) {
    s = nrow(tree$sna)
    sna = tree$sna
    sna.change = sample.int(min(4, sample.int(1, n = s)), n = s)
    sna.edge = sample(2:nrow(tree$edge), size = length(sna.change), replace = TRUE)
    sna[sna.change, 2:3] = tree$edge[sna.edge, 1:2]
    return(sna)
} 