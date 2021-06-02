# Differential expression function
diff_exp <- function(seqmatrix, a.grp, b.grp, thres, inf = FALSE)
{
  if (length(a.grp) == 1)
  {
    seqmatrix$A <- seqmatrix[,a.grp]
  } else {
    seqmatrix$A <- apply(seqmatrix[,a.grp],1,mean)
  }
  if (length(b.grp) == 1)
  {
    seqmatrix$B <- seqmatrix[,b.grp]
  } else {
    seqmatrix$B <- apply(seqmatrix[,b.grp],1,mean)
  }
  seqmatrix$log2fc <- log2(seqmatrix$B/seqmatrix$A)
  seqmat <- subset(seqmatrix, abs(seqmatrix[,"log2fc"]) >= thres)
  #seqmat <- seqmat[(seqmat$numberSamples == max(seqmat$numberSamples)),]
  #row.names(seqmat) <- seqmat[,1]
  #seqmat[,c(1,2)] = NULL
  if (inf == FALSE)
  {
    seqmat$log2fc[is.infinite(seqmat$log2fc)] = NA
    seqmat <- seqmat[complete.cases(seqmat),]
  }
  seqmat[,c("A","B","log2fc")] = NULL
  return(seqmat)
}

# Main Script
sequence.matrix <- dge_norm
seqmat_final <- data.frame()
thres = 2.6
while (dim(seqmat_final)[1] < 50)
{
  thres = thres - 0.1
  seqmat_final <- data.frame()
  for (num in 1:length(colnames(sequence.matrix)))
  {
    a.grp <- colnames(sequence.matrix)[num]
    b.grp <- colnames(sequence.matrix)[c(colnames(sequence.matrix)) != a.grp]
    seqmat <- diff_exp(sequence.matrix,a.grp,b.grp,thres, inf = FALSE)
    seqmat_final <<- rbind(seqmat_final,seqmat)
    seqmat_final <- seqmat_final[c(grep('[0-9]',row.names(seqmat_final),invert = T)),]
  }
  if (thres < 0.3)
  {
    break
  }
}

