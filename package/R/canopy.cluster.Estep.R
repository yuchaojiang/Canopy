# Expectation function
canopy.cluster.Estep = function(Tau,Mu,R,X){
    s=nrow(R) # number of mutations
    K=nrow(Mu) # number of mutation clusters
    Mu=pmax(Mu, 0.001)
    pG=matrix(nrow=K+1,ncol=s,data=log(Tau)) # hidden parameters specifying probability of which component generated each data item
    pG[1:K,]=pG[1:K,]+log(Mu)%*%t(R)+log(1-Mu)%*%(t(X-R))
    for(j in 1:ncol(R)){
        pG[K+1,]=pG[K+1,]+lbeta(R[,j]+1,X[,j]-R[,j]+1)
    }
    if(Tau[length(Tau)]!=0){
        pGtemp=pG
        pGtemp=pGtemp-matrix(ncol=ncol(pGtemp),nrow=nrow(pGtemp),
                             data=apply(pGtemp,2,max),byrow = TRUE) # prevent underflow
        pGtemp=exp(pGtemp)
        pGtemp=pGtemp/matrix(nrow=nrow(pG),ncol=ncol(pG),
                             data=colSums(pGtemp),byrow=TRUE)
        pG[K+1,(rank(pGtemp[K+1,],ties.method='random'))<=(ncol(pG)*(1-Tau[K+1]))]=-Inf 
    }
    pG=pG-matrix(ncol=ncol(pG),nrow=nrow(pG),data=apply(pG,2,max),byrow = TRUE) # prevent underflow
    pG=exp(pG)
    pG=pG/matrix(nrow=nrow(pG),ncol=ncol(pG),data=colSums(pG),byrow = TRUE)
    return(pG)
}