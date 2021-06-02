# p-value based Differential Expression Analysis using edgeR
group <- c(rep("A",numA),rep("B",numB))

# DGEList object 
dgList <- DGEList(counts = dge_norm, genes = rownames(dge_norm), group = group)
designMat <- model.matrix(~group)

# Estimate Dispersions
dgList <- estimateGLMCommonDisp(dgList, design=designMat)
dgList <- estimateGLMTrendedDisp(dgList, design=designMat)
dgList <- estimateGLMTagwiseDisp(dgList, design=designMat)

# Differential Expression
fit <- glmFit(dgList, designMat)
lrt <- glmLRT(fit, coef=2)
p = min(lrt$table$PValue)
d = dim(lrt$table)[1]

edgeR_result <- topTags(lrt, n = 50)
d = dim(edgeR_result$table)[1]

seqmat_final <- dge_norm[rownames(dge_norm) %in% edgeR_result$table$genes,]

# Significant DE Clones
#deGenes <- decideTestsDGE(lrt, p=0.001)
#deGenes <- rownames(lrt)[as.logical(deGenes)]
#plotSmear(lrt, de.tags=deGenes)
#abline(h=c(-1, 1), col=2)
