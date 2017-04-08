getQ = function(tree, Y, C) {
    Q = Y[, -1] %*% C  # whether SNAs precede CNAs
    sna.cna.temp=as.matrix(tree$sna[,2])%*%rep(1,ncol(Q))-as.matrix(rep(1,nrow(Q)))%*%tree$cna[,2]
    Q[Q==1 & sna.cna.temp>0]=0
    return(Q)
} 