falcon.output = function(readMatrix, tauhat, cn, st_bp, end_bp, nboot=NULL){
  if(is.null(nboot)){nboot = 10000}
  
  st_snp=c(1,tauhat)
  end_snp=c(tauhat,nrow(readMatrix))
  st_bp=st_bp[st_snp]
  end_bp=end_bp[end_snp]
  output=cbind(st_snp,end_snp,st_bp,end_bp,round(t(cn$ascn),3))
  colnames(output)[5:6]=c('Minor_copy','Major_copy')
  
  Major.sd=Minor.sd=rep(NA,nrow(output))
  output=cbind(output,Minor.sd,Major.sd)
  for(t in 1:nrow(output)){
    if(length(cn$Haplotype)==0) break
    if(t >= length(cn$Haplotype)) break
    if(length(cn$Haplotype[[t]])==0) next
    cat('Running bootstrap for segment',t, '...\n')
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
    
    filter=!(is.na(t.cn1) | is.na(t.cn2) | is.na(n.cn1) | is.na(n.cn2))
    t.cn1=t.cn1[filter]
    t.cn2=t.cn2[filter]
    n.cn1=n.cn1[filter]
    n.cn2=n.cn2[filter]
    
    cn1.boot=rep(NA,nboot)
    cn2.boot=rep(NA,nboot)
    for(i in 1:nboot){
      # if((i %%1000) ==0){ cat(i,'\t')}
      samp.temp=sample(1:length(t.cn1),replace = T)
      t.cn1.temp=t.cn1[samp.temp]
      t.cn2.temp=t.cn2[samp.temp]
      n.cn1.temp=n.cn1[samp.temp]
      n.cn2.temp=n.cn2[samp.temp]
      cn1.boot[i]=sum(t.cn1.temp)/sum(n.cn1.temp)
      cn2.boot[i]=sum(t.cn2.temp)/sum(n.cn2.temp)
    }
    output[t,"Major.sd"]=round(sd(cn1.boot),4)
    output[t,"Minor.sd"]=round(sd(cn2.boot),4)
  }
  return(output)
}
