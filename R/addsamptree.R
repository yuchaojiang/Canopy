addsamptree = function(tree, tree.new, diagnostics) {
    if (diagnostics == FALSE) {
        logr = tree.new$likelihood - tree$likelihood
        if (logr >= 0) {
            returntree = tree.new
        }
        if (logr < 0) {
            r = exp(logr)
            randr = runif(1, 0, 1)
            if (randr <= r) {
                returntree = tree.new
            } else if (randr > r) {
                returntree = tree
            }
        }
    } else if (diagnostics == TRUE) {
        logr = tree.new$likelihood - tree$likelihood
        if (logr >= 0) {
            returntree = tree.new
            cat("accept new tree! log-likelihood =", tree.new$likelihood, 
                "\n")
        }
        if (logr < 0) {
            r = exp(logr)
            randr = runif(1, 0, 1)
            if (randr <= r) {
                returntree = tree.new
                cat("accept new tree! log-likelihood =", tree.new$likelihood, 
                  "\n")
            } else if (randr > r) {
                returntree = tree
                cat("pertain old tree. log-likelihood =", tree$likelihood, 
                  "\n")
            }
        }
    }
    return(returntree)
} 
