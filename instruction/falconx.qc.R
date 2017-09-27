falconx.qc = function(readMatrix, biasMatrix, tauhat, cn, st_bp, end_bp, length.thres = NULL, delta.cn.thres = NULL){
  if(is.null(length.thres)){
    length.thres=10^6
  }
  if(is.null(delta.cn.thres)){
    delta.cn.thres=0.3
  }
  
  tauhat.filter=rep(T,length(tauhat))
  for(i.change in 1:length(tauhat)){
    temp=max(abs(cn$ascn[,i.change+1]-cn$ascn[,i.change]))
    if (temp<=delta.cn.thres){
      tauhat.filter[i.change]=F
    }
  }
  tauhat=tauhat[tauhat.filter]
  cn = getASCN.x(readMatrix, biasMatrix, tauhat=tauhat)
  
  st_snp=c(1,tauhat)
  end_snp=c(tauhat,nrow(readMatrix))
  st_bp=st_bp[st_snp]
  end_bp=end_bp[end_snp]
  output=cbind(st_snp,end_snp,st_bp,end_bp,t(cn$ascn))
  output.filter=(output[,"end_bp"]-output[,"st_bp"]+1)>=(length.thres)  # 1 Mb long at least
  output=output[output.filter,,drop=FALSE]
  tauhat=setdiff(unique(output[,"st_snp"],output[,"end_snp"]),c(1,nrow(readMatrix)))
  cn = getASCN.x(readMatrix, biasMatrix, tauhat=tauhat)
  if(nrow(output)>1){
    tauhat.filter=rep(T,length(tauhat))
    for(i.change in 1:length(tauhat)){
      temp=max(abs(cn$ascn[,i.change+1]-cn$ascn[,i.change]))
      if (temp<=0.3){
        tauhat.filter[i.change]=FALSE
      }
    }
    tauhat=tauhat[tauhat.filter]
    cn = getASCN.x(readMatrix, biasMatrix, tauhat=tauhat, threshold = 0.3) 
  }
  return(list(tauhat=tauhat, cn=cn))
}