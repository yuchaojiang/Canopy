canopy.simrun.diagnostic = function(sampchain, optK, K, writeskip, yRange = 100){
  
  chainLikeDF = rbindlist(
    lapply(seq_along(sampchain[[which(K == optK)]]), function(chainIndex) {
      myChain = sampchain[[which(K == optK)]][[chainIndex]]
      data.frame(
        chainIndex = chainIndex,
        treeIndex = seq_along(myChain) * writeskip,
        likelihood = sapply( myChain, function(myTree) myTree$likelihood )
      )
    })
  )
  
  p = list()
  p[[1]] = ggplot(data = chainLikeDF) + 
    geom_line( aes( x = treeIndex, y = likelihood, color = factor( chainIndex ) ) ) +
    guides(color=guide_legend(title="chainIndex"))
  p[[2]] = ggplot(data = chainLikeDF[likelihood > max(chainLikeDF$likelihood) - yRange]) + 
    geom_line( aes( x = treeIndex, y = likelihood, color = factor( chainIndex ) ) ) +
    guides(color=guide_legend(title="chainIndex"))
  return (grid.arrange(grobs = p, nrow = 1))
  
}
