# Normalization and Re-Scaling
#library(data.table)
#library(edgeR)
#library(limma)
#library(tcR)

dir.create(paste(fl.dir,cwd,"/A",sep = ""),mode = "0777")
dir.create(paste(fl.dir,cwd,"/B",sep = ""),mode = "0777")

 for (sam in 1:length(immdataA))
 {
   sample_name <- names(immdataA)[sam]
   samp <- immdataA[[sam]]
   samp <- samp[,c("CDR3.amino.acid.sequence","CDR3.nucleotide.sequence","Read.count","Read.proportion","V.gene","J.gene","D.gene")]
   colnames(samp) <- c("aminoAcid","nucleotide","count","frequencyCount","vGeneName","jGeneName","dGeneName")
   samp$cdr3Length <- nchar(samp$nucleotide)
   samp$vFamilyName <- strsplit2(samp$vGeneName, split = "-")[,1]
   samp$jFamilyName <- strsplit2(samp$jGeneName, split = "-")[,1]
   samp$dFamilyName <- strsplit2(samp$dGeneName, split = "-")[,1]
   write.table(samp, file = paste(fl.dir,cwd,"/A/",sample_name,".tsv",sep = ''),sep = "\t", quote = FALSE, row.names = FALSE)
 }
 
 for (sam in 1:length(immdataB))
 {
   sample_name <- names(immdataB)[sam]
   samp <- immdataB[[sam]]
   samp <- samp[,c("CDR3.amino.acid.sequence","CDR3.nucleotide.sequence","Read.count","Read.proportion","V.gene","J.gene","D.gene")]
   colnames(samp) <- c("aminoAcid","nucleotide","count","frequencyCount","vGeneName","jGeneName","dGeneName")
   samp$cdr3Length <- nchar(samp$nucleotide)
   samp$vFamilyName <- strsplit2(samp$vGeneName, split = "-")[,1]
   samp$jFamilyName <- strsplit2(samp$jGeneName, split = "-")[,1]
   samp$dFamilyName <- strsplit2(samp$dGeneName, split = "-")[,1]
   write.table(samp, file = paste(fl.dir,cwd,"/B/",sample_name,".tsv",sep = ''),sep = "\t", quote = FALSE, row.names = FALSE)
 }