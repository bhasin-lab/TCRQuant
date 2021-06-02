# Quantile normalization using raw count matrix
#library(data.table)
#library(limma)
#library(edgeR)

logcpm <- function(CountMatrix, method = "quantile")
{
  # DGE Object
  dge <- DGEList(CountMatrix)
  # Normalization by voom
  dge_voom <- voom(dge, plot = FALSE, normalize.method = method)
  dge_norm <- data.frame(dge_voom$E)
  return(dge_norm)
}

df2 <- data.frame(aminoAcid = unique.seqs$aminoAcid)
for (file in names(productive.raw.count))
{
  df <- productive.raw.count[[file]]
  df <- df[,c(1,2)]
  colnames(df) <- c("aminoAcid",file)
  df2 <- merge(df2,df, by = "aminoAcid", all = T)
}
#df2[is.na(df2)] = 0
row.names(df2) <- df2$aminoAcid
df2$aminoAcid = NULL
#df2[t(apply(df2, 1, is.na))] = 0
#df3 <- df2
df3 <- df2[complete.cases(df2),]
#df4 <- preprocessCore::normalize.quantiles(as.matrix(df3), copy = F)
if (dim(df3)[1] != 0)
{
  # Voom Normalization
  dge_norm <- logcpm(df3)
  dge_melt <- melt(dge_norm)
  note <- "filtered to common cdr3 sequences only"
} else {
  df3 <- df2
  df3[t(apply(df3, 1, is.na))] = 0
  dge_norm <- logcpm(df3)
  dge_melt <- melt(dge_norm)
  note <- "Common sequences not found. Taken all sequences and Normalized"
}


