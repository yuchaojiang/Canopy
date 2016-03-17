canopy.plottree = function(tree, pdf = NULL, pdf.name = NULL) {
    if (is.null(pdf)) {
        pdf = TRUE
    }
    if (pdf & is.null(pdf.name)) {
        stop("pdf.name has to be provided unless if pdf=FALSE!")
    }
    if (!is.null(pdf.name)) {
        pdf.split = strsplit(pdf.name, "\\.")[[1]]
        if (length(pdf.split) < 2 | pdf.split[2] != "pdf") {
            stop("pdf.name has to end with .pdf!")
        }
    }
    if (pdf) {
        pdf(file = pdf.name, height = 6, width = 6)
    }
    nf <- layout(matrix(c(1, 2, 3), 3, 1, byrow = TRUE), widths = c(3, 
        3, 3), heights = c(1.3, 1, 1), respect = TRUE)
    par(mar = c(1, 7, 1, 10))
    # plot tree
    K = ncol(tree$CM)
    plot(tree, label.offset = 0.1, type = "cladogram", direction = "d", 
        show.tip.label = FALSE)
    nodelabels()
    tiplabels()
    snaedge = rep(NA, nrow(tree$sna))
    for (k in 1:nrow(tree$sna)) {
        snaedge[k] = intersect(which(tree$edge[, 1] == tree$sna[k, 2]), 
            which(tree$edge[, 2] == tree$sna[k, 3]))
    }
    cnaedge = rep(NA, nrow(tree$cna))
    for (k in 1:nrow(tree$cna)) {
        cnaedge[k] = intersect(which(tree$edge[, 1] == tree$cna[k, 2]), 
            which(tree$edge[, 2] == tree$cna[k, 3]))
    }
    edge.label = sort(unique(c(snaedge, cnaedge)))
    edgelabels(paste("mut", 1:length(edge.label), sep = ""), edge.label, 
        frame = "n", col = 2, cex = 1.2)
    tiplabels("Normal", 1, adj = c(0.2, 1.5), frame = "n", cex = 1.2, 
        col = 4)
    tiplabels(paste("Clone", 1:(K - 2), sep = ""), 2:(K - 1), adj = c(0.5, 
        1.5), frame = "n", cex = 1.2, col = 4)
    tiplabels(paste("Clone", (K - 1), sep = ""), K, adj = c(0.8, 1.5), 
        frame = "n", cex = 1.2, col = 4)
    # plot clonal frequencies
    par(mar = c(1, 7, 0.5, 9.5))
    P = tree$P
    image(1:nrow(P), 1:ncol(P), axes = FALSE, ylab = "", xlab = "", 
        P, breaks = 0:100/100, col = tim.colors(100))
    axis(4, at = 1:ncol(P), colnames(P), cex.axis = 1.2, las = 1, tick = FALSE)
    abline(h = seq(0.5, ncol(P) + 0.5, 1), v = seq(0.5, nrow(P) + 0.5, 
        1), col = "grey")
    for (i in 1:nrow(P)) {
        for (j in 1:ncol(P)) {
            txt <- sprintf("%0.3f", P[i, j])
            if (P[i, j] <= 0.05 | P[i, j] >= 0.95) {
                text(i, j, txt, cex = 0.7, col = "white")
            } else {
                text(i, j, txt, cex = 0.7)
            }
        }
    }
    sna.name = rownames(tree$sna)
    cna.name = rownames(tree$cna)
    # plot mutations
    plot(c(0, 1), c(0, 1), ann = FALSE, bty = "n", type = "n", xaxt = "n", 
        yaxt = "n")
    for (i in 1:length(edge.label)) {
        txt = paste("mut", i, ": ", paste(c(sna.name[which(snaedge == 
            edge.label[i])], cna.name[which(cnaedge == edge.label[i])]), 
            collapse = ", "), sep = "")
        text(x = 0, y = 0.95 - 0.1 * (i - 1), txt, pos = 4, cex = 1.2)
    }
    if (!is.null(pdf.name)) {
        text(x = 0.5, y = 0.1, pdf.split[1], font = 2, cex = 1.2)
    }
    if (pdf) {
        dev.off()
    }
} 
