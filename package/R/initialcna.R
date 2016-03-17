initialcna = function(tree, cna.name) {
    k = (nrow(tree$edge) + 2)/2
    cna.no = length(cna.name)
    cna.edge = sample(2:nrow(tree$edge), size = cna.no, replace = TRUE)
    if (cna.no == 1) {
        cna.mat = t(as.matrix(c(cna.no, tree$edge[cna.edge, ])))
    } else {
        cna.mat = cbind(1:cna.no, tree$edge[cna.edge, ])
    }
    colnames(cna.mat) = c("cna", "cna.st.node", "cna.ed.node")
    rownames(cna.mat) = cna.name
    return(cna.mat)
} 
