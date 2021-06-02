#library(WGCNA)
#library(flashClust)
#library(LPCM)

# WGCNA Analysis
seq.cor <- cor(t(seqmat_final), method = "pearson")
adj <- adjacency(t(seqmat_final),type = "unsigned", power = 7)
TOM <- TOMsimilarityFromExpr(t(seqmat_final),networkType = "unsigned", TOMType = "unsigned", power = 7)
colnames(TOM) =rownames(TOM) =colnames(t(seqmat_final))
dissTOM = 1 - TOM
geneTree = flashClust(as.dist(dissTOM),method="average")
#plot(geneTree, xlab="", sub="",cex=0.5, hang = -1)
dynamicMods = cutreeDynamic(dendro = geneTree,  method="tree", minClusterSize = 4)
dynamicColors = labels2colors(dynamicMods)
#plotDendroAndColors(geneTree, dynamicColors, "Dynamic Tree Cut", dendroLabels = FALSE, hang = -1)

# Multi-Dimensional Scaling (MDS) combined with Mean-Shift Cluster
ms.wg <- cmdscale(dissTOM) 
MS.wg <- ms(ms.wg,scaled = 0, plot = F) # Mean-Shift Cluster
#plot(MS.wg)
