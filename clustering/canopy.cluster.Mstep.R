# Maximization function
canopy.cluster.Mstep = function (pG,R,X,Tau_Kplus1){
    s=nrow(R) # number of mutations
    K=nrow(pG)-1 # number of mutation clusters
    Tau=rep(NA,K+1)
    Tau[1:K]=(1-Tau_Kplus1)*apply(pG[1:K,],1,sum)/(s-sum(pG[K+1,]))
    Tau[K+1]=Tau_Kplus1
    pGtemp=pG[1:K,]
    Mu=(pGtemp%*%R)/(pGtemp%*%X)
    Mu=round(pmax(Mu,0.0001),4)
    return(list(Mu=Mu,Tau=Tau))
}