canopy.sample.cluster = function(R, X, sna_cluster, WM, Wm, epsilonM, epsilonm, C = NULL, 
                         Y, K, numchain, max.simrun, min.simrun, writeskip, projectname, 
                         cell.line = NULL, plot.likelihood = NULL) {
    if(length(sna_cluster)!=nrow(R)){
        stop('Length of sna_cluster should be the same as row numbers of R and X!')
    }
    if (!is.matrix(R)) {
        stop("R should be a matrix!")
    }
    if (!is.matrix(X)) {
        stop("X should be a matrix!")
    }
    if (!is.matrix(WM)) {
        stop("WM should be a matrix!")
    }
    if (!is.matrix(Wm)) {
        stop("Wm should be a matrix!")
    }
    if (min(K) < 2) {
        stop("Smallest number of subclones should be >= 2!\n")
    }
    if (is.null(cell.line)) {
        cell.line = FALSE
    }
    if (is.null(plot.likelihood)) {
        plot.likelihood = TRUE
    }
    if (is.null(C)) {
        C = diag(nrow(WM))
        colnames(C) = rownames(C) = rownames(WM)
    }
    if (any(colSums(C) != 1)) {
        stop("Matrix C should have one and only one 1 for each column!")
    }
    if ( plot.likelihood){
        pdf(file = paste(projectname, "_likelihood.pdf", sep = ""), width = 10, height = 5)
    }
    
    sampname = colnames(R)
    sna.name = rownames(R)
    cna.region.name = rownames(C)
    cna.name = colnames(C)
    sampchain = vector("list", length(K))
    ki = 1
    for (k in K) {
        cat("Sample in tree space with", k, "subclones\n")
        sampchaink = vector("list", numchain)
        sampchaink.lik=vector('list',numchain)
        sampchaink.accept.rate=vector('list',numchain)
        for (numi in 1:numchain) {  # numi: number of chain
            cat("\tRunning chain", numi, "out of", numchain, "...\n")
            ###################################### Tree initialization #####
            text = paste(paste(paste(paste("(", 1:(k - 1), ",", sep = ""), 
                                     collapse = ""), k, sep = ""), paste(rep(")", (k - 1)), 
                                                                         collapse = ""), ";", sep = "")
            runif.temp=runif(1)
            if(k == 5 & runif.temp<0.5){
                text = c('(1,((2,3),(4,5)));')
            }else if(k == 6 & runif.temp < 1/3){
                text = c('(1,((2,3),(4,(5,6))));')
            }else if(k == 6 & runif.temp > 2/3){
                text = c('(1,(2,((3,4),(5,6))));')
            }else if(k == 7 & runif.temp > 1/4 & runif.temp <= 2/4){
                text=c('(1,((2,3),(4,(5,(6,7)))));')
            }else if(k == 7 & runif.temp > 2/4 & runif.temp <= 3/4){
                text = c('(1,((2,3),((4,5),(6,7))));')
            }else if(k == 7 & runif.temp > 3/4){
                text = c('(1,((2,(3,4)),(5,(6,7))));')
            }
            tree <- read.tree(text = text)
            tree$sna.cluster=initialsna(tree,paste('cluster',unique(sna_cluster),sep=''))
            sna.mat = cbind(sna=1:nrow(R),(tree$sna.cluster)[sna_cluster,2:3])
            colnames(sna.mat) = c("sna", "sna.st.node", "sna.ed.node")
            rownames(sna.mat) = sna.name
            tree$sna=sna.mat
            #tree$sna = initialsna(tree, sna.name)
            # if(k>=5){tree$relation=getrelation(tree)}
            tree$Z = getZ(tree, sna.name)
            tree$P = initialP(tree, sampname, cell.line)
            tree$cna = initialcna(tree, cna.name)
            tree$cna.copy = initialcnacopy(tree)
            CMCm = getCMCm(tree, C)  # get major and minor copy per clone
            tree$CM = CMCm[[1]]
            tree$Cm = CMCm[[2]]  # major/minor copy per clone
            tree$Q = getQ(tree, Y, C)
            tree$H = tree$Q  # start as all SNAs that precede CNAs land 
            # on major copies
            tree$VAF = getVAF(tree, Y)
            tree$likelihood = getlikelihood(tree, R, X, WM, Wm, epsilonM, 
                                            epsilonm)
            ###################################### Sample in tree space #####
            sampi = 1
            writei = 1
            samptree = vector("list", max.simrun)
            samptree.lik=rep(NA, max.simrun)
            samptree.accept=rep(NA, max.simrun)
            samptree.accept.rate=rep(NA, max.simrun)
            while(sampi <= max.simrun){
                if( sampi <= min.simrun){
                    ######### sample sna mutation cluster positions
                    tree.new=tree
                    tree.new$sna.cluster=sampsna.cluster(tree)
                    sna.mat = cbind(sna=1:nrow(R),(tree.new$sna.cluster)[sna_cluster,2:3])
                    colnames(sna.mat) = c("sna", "sna.st.node", "sna.ed.node")
                    rownames(sna.mat) = sna.name
                    tree.new$sna=sna.mat
                    tree.new$Z = getZ(tree.new, sna.name)
                    tree.new$Q = getQ(tree.new, Y, C)
                    tree.new$H = tree.new$Q
                    tree.new$VAF = getVAF(tree.new, Y)
                    tree.new$likelihood = getlikelihood(tree.new, R, X, 
                                                        WM, Wm, epsilonM, epsilonm)
                    tree.temp=addsamptree(tree,tree.new)
                    tree=tree.temp[[1]]
                    samptree.accept[sampi]=tree.temp[[2]]
                    if (sampi%%writeskip == 0) {
                        samptree[[writei]] = tree
                        writei = writei + 1
                    }
                    samptree.lik[sampi]=tree$likelihood
                    samptree.accept.rate[sampi]=mean(samptree.accept[max(1,sampi-999):sampi])
                    sampi = sampi + 1
                } else{
                    ######### sample sna positions
                    tree.new = tree
                    tree.new$sna = sampsna(tree)
                    tree.new$Z = getZ(tree.new, sna.name)
                    tree.new$Q = getQ(tree.new, Y, C)
                    tree.new$H = tree.new$Q
                    tree.new$VAF = getVAF(tree.new, Y)
                    tree.new$likelihood = getlikelihood(tree.new, R, X, 
                                                        WM, Wm, epsilonM, epsilonm)
                    tree.temp=addsamptree(tree,tree.new)
                    tree=tree.temp[[1]]
                    samptree.accept[sampi]=tree.temp[[2]]
                    if (sampi%%writeskip == 0) {
                        samptree[[writei]] = tree
                        writei = writei + 1
                    }
                    samptree.lik[sampi]=tree$likelihood
                    samptree.accept.rate[sampi]=mean(samptree.accept[max(1,sampi-999):sampi])
                    if ((sampi >= 2*min.simrun) & (samptree.lik[sampi] <= mean(samptree.lik[max((sampi-1000),1):max((sampi-1),1)])) &
                        (samptree.accept.rate[sampi] <= mean(samptree.accept.rate[max((sampi-1000),1):max((sampi-1),1)])) &
                        (samptree.accept.rate[sampi] <= 0.1)) break
                    sampi = sampi + 1
                }
                ######## sample cna positions
                tree.new = tree
                tree.new$cna = sampcna(tree)
                CMCm = getCMCm(tree.new, C)
                tree.new$CM = CMCm[[1]]
                tree.new$Cm = CMCm[[2]]
                tree.new$Q = getQ(tree.new, Y, C)
                tree.new$H = tree.new$Q
                tree.new$VAF = getVAF(tree.new, Y)
                tree.new$likelihood = getlikelihood(tree.new, R, X, 
                                                    WM, Wm, epsilonM, epsilonm)
                tree.temp=addsamptree(tree,tree.new)
                tree=tree.temp[[1]]
                samptree.accept[sampi]=tree.temp[[2]]
                if (sampi%%writeskip == 0) {
                    samptree[[writei]] = tree
                    writei = writei + 1
                }
                samptree.lik[sampi]=tree$likelihood
                samptree.accept.rate[sampi]=mean(samptree.accept[max(1,sampi-999):sampi])
                if ((sampi >= 2*min.simrun) & (samptree.lik[sampi] <= mean(samptree.lik[max((sampi-1000),1):max((sampi-1),1)])) &
                    (samptree.accept.rate[sampi] <= mean(samptree.accept.rate[max((sampi-1000),1):max((sampi-1),1)])) &
                    (samptree.accept.rate[sampi] <= 0.1)) break
                sampi = sampi + 1
                ######## sample P (clonal proportions)
                tree.new = tree
                tree.new$P = sampP(tree.new, cell.line)
                tree.new$VAF = getVAF(tree.new, Y)
                tree.new$likelihood = getlikelihood(tree.new, R, X, 
                                                    WM, Wm, epsilonM, epsilonm)
                tree.temp=addsamptree(tree,tree.new)
                tree=tree.temp[[1]]
                samptree.accept[sampi]=tree.temp[[2]]
                if (sampi%%writeskip == 0) {
                    samptree[[writei]] = tree
                    writei = writei + 1
                }
                samptree.lik[sampi]=tree$likelihood
                samptree.accept.rate[sampi]=mean(samptree.accept[max(1,sampi-999):sampi])
                if ((sampi >= 2*min.simrun) & (samptree.lik[sampi] <= mean(samptree.lik[max((sampi-1000),1):max((sampi-1),1)])) &
                    (samptree.accept.rate[sampi] <= mean(samptree.accept.rate[max((sampi-1000),1):max((sampi-1),1)])) &
                    (samptree.accept.rate[sampi] <= 0.1)) break
                sampi = sampi + 1
                ######## sample major and minor copy number
                tree.new = tree
                tree.new$cna.copy = sampcnacopy(tree.new)
                CMCm = getCMCm(tree.new, C)
                tree.new$CM = CMCm[[1]]
                tree.new$Cm = CMCm[[2]]
                tree.new$VAF = getVAF(tree.new, Y)
                tree.new$likelihood = getlikelihood(tree.new, R, X, 
                                                    WM, Wm, epsilonM, epsilonm)
                tree.temp=addsamptree(tree,tree.new)
                tree=tree.temp[[1]]
                samptree.accept[sampi]=tree.temp[[2]]
                if (sampi%%writeskip == 0) {
                    samptree[[writei]] = tree
                    writei = writei + 1
                }
                samptree.lik[sampi]=tree$likelihood
                samptree.accept.rate[sampi]=mean(samptree.accept[max(1,sampi-999):sampi])
                if ((sampi >= 2*min.simrun) & (samptree.lik[sampi] <= mean(samptree.lik[max((sampi-1000),1):max((sampi-1),1)])) &
                    (samptree.accept.rate[sampi] <= mean(samptree.accept.rate[max((sampi-1000),1):max((sampi-1),1)])) &
                    (samptree.accept.rate[sampi] <= 0.1)) break
                sampi = sampi + 1
                ######## sample whether SNA falls in major or minor allele
                if (any(tree$Q == 1)) {
                    tree.new = tree
                    q.temp = which(tree.new$Q == 1)
                    q.temp.change = q.temp[sample.int(1, n = length(q.temp))]
                    tree.new$H[q.temp.change] = 1 - tree.new$H[q.temp.change]
                    tree.new$VAF = getVAF(tree.new, Y)
                    tree.new$likelihood = getlikelihood(tree.new, R, X, 
                                                        WM, Wm, epsilonM, epsilonm)
                    tree.temp=addsamptree(tree,tree.new)
                    tree=tree.temp[[1]]
                    samptree.accept[sampi]=tree.temp[[2]]
                    if (sampi%%writeskip == 0) {
                        samptree[[writei]] = tree
                        writei = writei + 1
                    }
                    samptree.lik[sampi]=tree$likelihood
                    samptree.accept.rate[sampi]=mean(samptree.accept[max(1,sampi-999):sampi])
                    if ((sampi >= 2*min.simrun) & (samptree.lik[sampi] <= mean(samptree.lik[max((sampi-1000),1):max((sampi-1),1)])) &
                        (samptree.accept.rate[sampi] <= mean(samptree.accept.rate[max((sampi-1000),1):max((sampi-1),1)])) &
                        (samptree.accept.rate[sampi] <= 0.1)) break
                    sampi = sampi + 1
                }
            }
            sampchaink[[numi]] = samptree[1:(writei - 1)]
            sampchaink.lik[[numi]]=samptree.lik
            sampchaink.accept.rate[[numi]]=samptree.accept.rate
        }
        ###################################### plotting and saving #####
        if (plot.likelihood) {
            par(mfrow=c(1,2))
            xmax=ymin=ymax=rep(NA,numchain)
            for(i in 1:numchain){
                xmax[i]=max(which((!is.na(sampchaink.lik[[i]]))))
                ymin[i]=sampchaink.lik[[i]][1]
                ymax[i]=sampchaink.lik[[i]][xmax[i]]
            }
            
            plot(sampchaink.lik[[1]],xlim=c(1,max(xmax)),ylim=c(min(ymin),max(ymax)),
                 xlab='Iteration',ylab='Log-likelihood',type='l',
                 main=paste('Post. likelihood:',k,'branches'))
            for(numi in 2:numchain){
                points(sampchaink.lik[[numi]],xlim=c(1,max(xmax)),ylim=c(min(ymin),max(ymax)),col=numi,type='l')
            }
            
            plot(sampchaink.accept.rate[[1]],ylim=c(0,1),xlim=c(1,max(xmax)),
                 xlab='Iteration',ylab='Acceptance rate',type='l',
                 main=paste('Acceptance rate:',k,'branches'))
            for(numi in 2:numchain){
                points(sampchaink.accept.rate[[numi]],ylim=c(0,1),xlim=c(1,max(xmax)),col=numi,type='l')
            }
            par(mfrow=c(1,1))
        }
        sampchain[[ki]] = sampchaink
        
        ki = ki + 1
    }
    if(plot.likelihood) {
        dev.off()
    }
    return(sampchain)
} 
