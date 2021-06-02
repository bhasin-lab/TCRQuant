# Mapping of data points onto SOM code vectors
#library(som)
#library(reshape2)

smap <- function(in.som, seqmat, d, alpha, label = "Unspecified")
{
  data <- data.frame(in.som$data)
  colnames(data) <- colnames(seqmat)
  code <- data.frame(in.som$code)
  colnames(code) <- colnames(seqmat)
  cell <- in.som$visual[,1:2]
  cell$rownum <- cell$x + (cell$y*in.som$xdim) + 1
  rownum <- in.som$code.sum$x + (in.som$code.sum$y*in.som$xdim) + 1
  code2 <- data.frame(value = t(code[d,]), sample = colnames(code))
  g <- ggplot(data = code2, aes(y = code2[,1], x = sample, group = 1)) + geom_line(color="red") + ylim(c(-3,3)) + geom_point()
  data2 <- data[cell$rownum == d,]
  n = in.som$code.sum[d,3]
  #write.table(data2, file = paste("~/Desktop/","P5_",d,".xls",sep = ""),sep = "\t",quote = F)
  data3 <- data.frame(t(data2), sample = colnames(data2))
  df_final <- melt(data3, id = "sample")
  g <- g + geom_line(data = df_final, aes(y = value, x = sample, group = variable), color = "gray", alpha = alpha) + 
       ggtitle(paste(label,"with n =",n)) + ylab("Scaled Normalized Counts") + 
       theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
  return(g)
}

x = 4
y = 4
nz = 1
while(nz != 0)
{
  in.som <- som(som::normalize(seqmat_final),xdim = x, ydim = y)
  nz = nrow(in.som$code.sum[(in.som$code.sum$nobs < 2),])
  if (x < y)
  {
    y = y - 1
  } else {
    x = x - 1
  }
}
num = nrow(in.som$code.sum)
#in.som <- som(som::normalize(seqmat_final),xdim = 2, ydim = 1)
#pheatmap(seqmat_final, cluster_rows = T, cluster_cols = F)
