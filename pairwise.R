logcpm <- function(CountMatrix, method = "quantile")
{
  # DGE Object
  dge <- DGEList(CountMatrix)
  # Normalization by voom
  dge_voom <- voom(dge, plot = FALSE, normalize.method = method)
  dge_norm <- data.frame(dge_voom$E)
  return(dge_norm)
}

# Alpha-Beta Pairwise correlation
# Alpha chain Sequences
tra1 <- productive.TRB.nt[[1]]
tra1 <- data.frame(aminoAcid = tra1[grep("TRA_*",tra1$vFamilyName),1])
for (file in names(productive.TRB.nt))
{
  tra <- productive.TRB.nt[[file]]
  tra <- tra[grep("TRA_*",tra$vFamilyName),c(1,3)]
  tra <- aggregate(count ~ aminoAcid, data = tra, FUN = sum)
  colnames(tra) <- c("aminoAcid",file)
  tra1 <- merge(tra1,tra, by = "aminoAcid", all = T)
}
tra1 <- tra1[complete.cases(tra1),]
tra1 <- tra1[!(duplicated(tra1)),]
#tra1[t(apply(tra1, 1, is.na))] = 0
row.names(tra1) <- tra1$aminoAcid
tra1$aminoAcid = NULL
#tra1 <- tra1 + 1
tra_norm <- logcpm(tra1)
T_tra_norm <- t(tra_norm)

# Beta chain Sequences
trb1 <- productive.TRB.nt[[1]]
trb1 <- data.frame(aminoAcid = trb1[grep("TRB_*",trb1$vFamilyName),1])
for (file in names(productive.TRB.nt))
{
  trb <- productive.TRB.nt[[file]]
  trb <- trb[grep("TRB_*",trb$vFamilyName),c(1,3)]
  trb <- aggregate(count ~ aminoAcid, data = trb, FUN = sum)
  colnames(trb) <- c("aminoAcid",file)
  trb1 <- merge(trb1,trb, by = "aminoAcid", all = T)
}
trb1 <- trb1[complete.cases(trb1),]
trb1 <- trb1[!(duplicated(trb1)),]
#trb1[t(apply(trb1, 1, is.na))] = 0
row.names(trb1) <- trb1$aminoAcid
trb1$aminoAcid = NULL
#trb1 <- trb1 + 1
trb_norm <- logcpm(trb1)
T_trb_norm <- t(trb_norm)

# Get perfectly Correlated Sequences
t_cor <- cor(T_tra_norm,T_trb_norm)
t_cor_melt <- melt(t_cor, alpha = rownames(t_cor), beta = colnames(t_cor))
colnames(t_cor_melt) <- c("alpha","beta","correlation")
t_cor_melt <- t_cor_melt[complete.cases(t_cor_melt),]
t_paired <- t_cor_melt[(t_cor_melt$correlation >= 0.9),]

# Map sequences to productive sequences table
t_list <- unique(c(as.character(t_paired$alpha),as.character(t_paired$beta)))
for (i in 1:length(productive.TRB.aa))
{
  p.aa <- productive.TRB.aa[[i]]
  p.aa <- p.aa[p.aa$aminoAcid %in% t_list,]
  productive.TRB.aa[[i]] <- p.aa
}

for (i in 1:length(immdata))
{
  p.aa <- immdata[[i]]
  p.aa <- p.aa[p.aa$CDR3.amino.acid.sequence %in% t_list,]
  immdata[[i]] <- p.aa
}

for (i in 1:length(productive.TRB.nt))
{
  p.aa <- productive.TRB.nt[[i]]
  p.aa <- p.aa[p.aa$aminoAcid %in% t_list,]
  productive.TRB.nt[[i]] <- p.aa
}