initialsna = function(tree, sna.name) {
    sna.no = length(sna.name)
    if(nrow(tree$edge)>2){
      sna.edge = sample(2:nrow(tree$edge), size = sna.no, replace = TRUE)
    } else{
      sna.edge = rep(2, sna.no)
    }
    sna.mat = cbind(1:sna.no, tree$edge[sna.edge, ])
    colnames(sna.mat) = c("sna", "sna.st.node", "sna.ed.node")
    rownames(sna.mat) = sna.name
    return(sna.mat)
} 
