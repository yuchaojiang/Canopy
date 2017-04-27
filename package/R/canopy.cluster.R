canopy.cluster=function(R, X, num_cluster, num_run, Mu.init = NULL,
                        Tau_Kplus1 = NULL){
    if(is.null(Tau_Kplus1)){
        Tau_Kplus1=0    # proportion of noise, uniformly distributed between 0 and 1
    }
    VAF=R/X
    s=nrow(R)
    r=pmax(R,1);x=pmax(X,1) # for log()
    Mu_output=Tau_output=pGrank_output=bic_output=vector('list',length(num_cluster))
    for(K in num_cluster){
        cat('Running EM with',K,'clusters...\t')
        Mu_run=Tau_run=pGrank_run=bic_run=vector('list',num_run)
        for(run in 1:num_run){
            cat(run,'  ')
            bic.temp=0
            Tau=rep(NA,K+1)
            Tau[K+1]=Tau_Kplus1 
            Tau[1:K]=(1-Tau_Kplus1)/K
            
            if(K==1){
                Mu=t(as.matrix(apply(R/X,2,mean)))
            } else{
                if (run==1 & (!is.null(Mu.init))){
                    Mu=Mu.init
                } else if(run<=(num_run/2)){
                    # using hierarchical clustering to find initial values of centers
                    VAF.pheat=pheatmap(VAF,cluster_rows = TRUE,cluster_cols = FALSE,kmeans_k=K,silent=TRUE, clustering_distance_rows = "euclidean")
                    Mu=pmax(VAF.pheat$kmeans$centers,0.001)
                } else{
                    if(ncol(R)>1){
                        VAF.pheat=pheatmap(VAF,cluster_rows = TRUE,cluster_cols = FALSE,kmeans_k=K,silent=TRUE, clustering_distance_rows = "correlation")
                        Mu=pmax(VAF.pheat$kmeans$centers,0.001) 
                    } else{
                        VAF.pheat=pheatmap(VAF,cluster_rows = TRUE,cluster_cols = FALSE,kmeans_k=K,silent=TRUE, clustering_distance_rows = "euclidean")
                        Mu=pmax(VAF.pheat$kmeans$centers,0.001)
                    }
                }
            }
            diff=1
            numiters=1
            while(diff>0.001 || numiters <= 30){
                numiters=numiters+1
                pG=canopy.cluster.Estep(Tau,Mu,r,x)
                curM=canopy.cluster.Mstep(pG,R,X,Tau_Kplus1)
                curTau=curM$Tau
                curMu=curM$Mu
                
                diff=max(max(abs(Tau-curTau)),max(abs(Mu-curMu)))
                Mu=curMu
                Tau=curTau
                #cat('Iteration:',numiters-1,'\t','diff =',diff,'\n')
            }
            dim(pG)
            pGrank=apply(pG,2,which.max)
            for (i in 1:s){
                if(pGrank[i]<=K){
                    muk=Mu[pGrank[i],]
                    for(j in 1:ncol(R)){
                        bic.temp=bic.temp+log(Tau[pGrank[i]])+r[i,j]*log(muk[j])+(x[i,j]-r[i,j])*log(1-muk[j])
                    }
                }
                if(pGrank[i]==(K+1)){
                    for(j in 1:ncol(R)){
                        bic.temp=bic.temp+log(Tau[pGrank[i]])+lbeta(r[i,j]+1,x[i,j]-r[i,j]+1)
                    }
                }
            }
            bic.temp=2*bic.temp-3*(length(Tau)-2+length(Mu))*log(length(R)+length(X))
            Mu_run[[run]]=Mu
            Tau_run[[run]]=Tau
            pGrank_run[[run]]=pGrank
            bic_run[[run]]=bic.temp
        }
        Mu_output[[which(num_cluster==K)]]=Mu_run[[which.max(bic_run)]]
        Tau_output[[which(num_cluster==K)]]=Tau_run[[which.max(bic_run)]]
        pGrank_output[[which(num_cluster==K)]]=pGrank_run[[which.max(bic_run)]]
        bic_output[[which(num_cluster==K)]]=bic_run[[which.max(bic_run)]]
        cat('\n')
    }
    bic_output=as.numeric(bic_output)
    Mu=round(Mu_output[[which.max(bic_output)]],3)
    Tau=round(Tau_output[[which.max(bic_output)]],3)
    pGrank=pGrank_output[[which.max(bic_output)]]
    sna_cluster=pGrank
    return(list(bic_output=bic_output,Mu=Mu,Tau=Tau,sna_cluster=sna_cluster))
}
                        