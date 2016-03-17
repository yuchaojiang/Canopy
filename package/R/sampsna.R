sampsna = function(tree) {
    s = nrow(tree$sna)
    sna = tree$sna
    sna.change = sample.int(sample.int(1, n = s), n = s)
    sna.edge = sample(2:nrow(tree$edge), size = length(sna.change), 
        replace = TRUE)
    sna[sna.change, 2] = tree$edge[sna.edge, 1]
    sna[sna.change, 3] = tree$edge[sna.edge, 2]
    return(sna)
} 
