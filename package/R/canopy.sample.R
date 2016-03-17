canopy.sample = function(R, X, WM, Wm, epsilonM, epsilonm, C = NULL, 
    Y, K, numchain, simrun, writeskip, projectname, cell.line = NULL,
    diagnostics = NULL, plot.likelihood = NULL) {
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
    if (min(K) < 3) {
        stop("Smallest number of subclones should be >= 3!\n")
    }
    if (is.null(cell.line)) {
        cell.line = FALSE
    }
    if (is.null(diagnostics)) {
        diagnostics = FALSE
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
    sampname = colnames(R)
    sna.name = rownames(R)
    cna.region.name = rownames(C)
    cna.name = colnames(C)
    sampchain = vector("list", length(K))
    ki = 1
    for (k in K) {
        cat("Sample in tree space with", k, "subclones\n")
        sampchaink = vector("list", numchain)
        for (numi in 1:numchain) {
            cat("\tRunning chain", numi, "out of", numchain, "...\n")
            ###################################### Tree initialization #####
            text = paste(paste(paste(paste("(", 1:(k - 1), ",", sep = ""), 
                collapse = ""), k, sep = ""), paste(rep(")", (k - 1)), 
                collapse = ""), ";", sep = "")
            tree <- read.tree(text = text)
            tree$sna = initialsna(tree, sna.name)
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
            samptree = vector("list", simrun)
            while (sampi <= simrun) {
                # sample sna positions
                tree.new = tree
                tree.new$sna = sampsna(tree)
                tree.new$Z = getZ(tree.new, sna.name)
                tree.new$Q = getQ(tree.new, Y, C)
                tree.new$H = tree.new$Q
                tree.new$VAF = getVAF(tree.new, Y)
                tree.new$likelihood = getlikelihood(tree.new, R, X, 
                  WM, Wm, epsilonM, epsilonm)
                tree = addsamptree(tree, tree.new, diagnostics)
                if (sampi%%writeskip == 0) {
                  samptree[[writei]] = tree
                  writei = writei + 1
                }
                sampi = sampi + 1
                # sample cna positions
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
                tree = addsamptree(tree, tree.new, diagnostics)
                if (sampi%%writeskip == 0) {
                  samptree[[writei]] = tree
                  writei = writei + 1
                }
                sampi = sampi + 1
                # sample P (clonal proportions)
                tree.new = tree
                tree.new$P = sampP(tree.new, cell.line)
                tree.new$VAF = getVAF(tree.new, Y)
                tree.new$likelihood = getlikelihood(tree.new, R, X, 
                  WM, Wm, epsilonM, epsilonm)
                tree = addsamptree(tree, tree.new, diagnostics)
                if (sampi%%writeskip == 0) {
                  samptree[[writei]] = tree
                  writei = writei + 1
                }
                sampi = sampi + 1
                # sample major and minor copy number
                tree.new = tree
                tree.new$cna.copy = sampcnacopy(tree.new)
                CMCm = getCMCm(tree.new, C)
                tree.new$CM = CMCm[[1]]
                tree.new$Cm = CMCm[[2]]
                tree.new$VAF = getVAF(tree.new, Y)
                tree.new$likelihood = getlikelihood(tree.new, R, X, 
                  WM, Wm, epsilonM, epsilonm)
                tree = addsamptree(tree, tree.new, diagnostics)
                if (sampi%%writeskip == 0) {
                  samptree[[writei]] = tree
                  writei = writei + 1
                }
                sampi = sampi + 1
                # sample whether SNA falls in major or minor allele
                if (any(tree$Q == 1)) {
                  tree.new = tree
                  q.temp = which(tree.new$Q == 1)
                  q.temp.change = q.temp[sample.int(1, n = length(q.temp))]
                  tree.new$H[q.temp.change] = 1 - tree.new$H[q.temp.change]
                  tree.new$VAF = getVAF(tree.new, Y)
                  tree.new$likelihood = getlikelihood(tree.new, R, X, 
                    WM, Wm, epsilonM, epsilonm)
                  tree = addsamptree(tree, tree.new, diagnostics)
                  if (sampi%%writeskip == 0) {
                    samptree[[writei]] = tree
                    writei = writei + 1
                  }
                  sampi = sampi + 1
                }
            }
            sampchaink[[numi]] = samptree[1:(writei - 1)]
        }
        ###################################### plotting and saving #####
        if (plot.likelihood) {
            plotpostlikelihood(sampchaink, projectname, k, numchain)
        }
        sampchain[[ki]] = sampchaink
        ki = ki + 1
    }
    return(sampchain)
} 
