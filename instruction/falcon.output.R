falcon.output = function(readMatrix, tauhat, cn, st_bp, end_bp, nboot=NULL){
  if(is.null(nboot)){nboot = 10000}
  
  st_snp=c(1,tauhat)
  end_snp=c(tauhat,nrow(readMatrix))
  st_bp=st_bp[st_snp]
  end_bp=end_bp[end_snp]
  output=cbind(st_snp,end_snp,st_bp,end_bp,t(cn$ascn))
  colnames(output)[5:6]=c('Minor_copy','Major_copy')
  
  Major.sd=Minor.sd=rep(NA,nrow(output))
  output=cbind(output,Minor.sd,Major.sd)
  for(t in 1:nrow(output)){
    if(length(cn$Haplotype[[t]])==0) next
    cat('Running bootstrap for segment',t, '...')
    temp=readMatrix[output[t,1]:output[t,2],]
    haplo.temp=cn$Haplotype[[t]]
    t.cn1=t.cn2=n.cn1=n.cn2=rep(NA,nrow(temp))
    for(i in 1:length(haplo.temp)){
      if(haplo.temp[i]=='A'){
        t.cn1[i]=temp[i,'AT']
        t.cn2[i]=temp[i,'BT']
        n.cn1[i]=temp[i,'AN']
        n.cn2[i]=temp[i,'BN']
      } else {
        t.cn1[i]=temp[i,'BT']
        t.cn2[i]=temp[i,'AT']
        n.cn1[i]=temp[i,'BN']
        n.cn2[i]=temp[i,'AN']
      }
    }
    
    AN = readMatrix$AN
    BN = readMatrix$BN
    AT = readMatrix$AT
    BT = readMatrix$BT
    rdep=median(AT + BT)/median(AN + BN)
    t.cn1=t.cn1/rdep
    t.cn2=t.cn2/rdep
    sum(t.cn1)/sum(n.cn1)
    sum(t.cn2)/sum(n.cn2)
    
    cn1.boot=rep(NA,10000)
    cn2.boot=rep(NA,10000)
    for(i in 1:10000){
      # if((i %%1000) ==0){ cat(i,'\t')}
      samp.temp=sample(1:length(t.cn1),replace = T)
      t.cn1.temp=t.cn1[samp.temp]
      t.cn2.temp=t.cn2[samp.temp]
      n.cn1.temp=n.cn1[samp.temp]
      n.cn2.temp=n.cn2[samp.temp]
      cn1.boot[i]=sum(t.cn1.temp)/sum(n.cn1.temp)
      cn2.boot[i]=sum(t.cn2.temp)/sum(n.cn2.temp)
    }
    output[t,"Major.sd"]=sd(cn1.boot)
    output[t,"Minor.sd"]=sd(cn2.boot)
  }
  return(output)
}