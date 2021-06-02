#!/usr/bin/env Rscript

#.libPaths(c("/home/hskhalsa/R/x86_64-pc-linux-gnu-library/3.5/","/home/hskhalsa/R/x86_64-pc-linux-gnu-library/3.5.1/R-3.5.1/library/"))

library(rmarkdown)
library(flexdashboard)

src = '/home/ubuntu/rpanchal/tcr_pipeline'
fl.dir = '/var/www/html/tcr_page/'
args = commandArgs(TRUE)
cwd = args[1]
fil = args[2]

rmarkdown::render('/home/ubuntu/rpanchal/tcr_pipeline/tcr_main.Rmd', output_dir=paste(fl.dir,cwd,sep=""), knit_root_dir=paste(fl.dir,cwd,sep=""), params = list(cwd = cwd, fil = fil))
