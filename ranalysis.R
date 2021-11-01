#!/usr/bin/env Rscript

#.libPaths(c("/opt/R/3.6.3/","/opt/R/3.6.3/lib/R/library/"))

library(rmarkdown)
library(flexdashboard)

src = './'
fl.dir = 'opt/localdata/sarthak/projects/TCR/data/'
#args = commandArgs(TRUE)
cwd = '/MBH_Fastq'
fil = 'Yes'

rmarkdown::render('./tcr_main.Rmd', output_dir=paste(fl.dir,cwd,sep=""), knit_root_dir=paste(fl.dir,cwd,sep=""), params = list(cwd = cwd, fil = fil))
