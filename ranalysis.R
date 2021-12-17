#!/usr/bin/env Rscript

#.libPaths(c("/opt/R/3.6.3/","/opt/R/3.6.3/lib/R/library/"))

library(rmarkdown)
library(flexdashboard)
library(argparse)

#src = './'
#fl.dir = 'opt/localdata/sarthak/projects/TCR/data/'
#args = commandArgs(TRUE)
#cwd = '/MBH_Fastq'
#fil = 'Yes'

parser <- ArgumentParser()
parser$add_argument("-pA", "--path_to_fileA", help="Path to input meta file list Group A (required)")
parser$add_argument("-pB", "--path_to_fileB", help="Path to input meta file list Group B (required)")
parser$add_argument("-d", "--cwd", help="Working directory path")
parser$add_argument("-f", "--filter", help="Filter")

args <- parser$parse_args()
cwd <- args$cwd
fil <- args$filter
pathA <- args$path_to_fileA
pathB <- args$path_to_fileB

rmarkdown::render('./tcr_main.Rmd', output_dir=cwd, knit_root_dir=cwd,
                  params = list(cwd = cwd, fil = fil, pathA = pathA, pathB = pathB))
