################################################################
##        REMOVE SEQUENCES THAT ARE NOT IN METADATA 
##        REMOVE SEQUENCES THAT ARE LABORATORY TEST STRAINS
##  date: 26 October 2020
###############################################################




library(dplyr)
library(tidyr)
library(stringr)
library(reutils)
library(ape)
library(rentrez)
library(reutils)
library(biofiles)
library(Biostrings)
library(seqinr)
library("argparse")


## Preparing environment
rm(list=ls())

setwd('~/Documents/RabiesPractice/data')

parser <- ArgumentParser()

parser$add_argument("-f", "--fasta", type="character",
                    help="sequences in fasta format")
parser$add_argument("-m", "--meta", type="character",
                    help="meta data, in tab separated format")
parser$add_argument("-o", "--output_fasta", type="character",
                    help="path to output fasta with sequences removed")

args <- parser$parse_args()

if (is.null(args$fasta) || is.null(args$meta)) {
  arg_parser$print_help()
  stop("You must specify the path for all three files: fasta, meta and output_fasta", call.=FALSE)
}

##WITH PARSER
#meta = read.table(args$meta, header = TRUE)
#seq = read.fasta(args$fasta)

##HARD CODE
meta <- read.delim("/Volumes/@home/rabies/data/ncbi_cleaned.tab")
seq <- read.fasta('/Volumes/@home/rabies/data/ncbi_RABV_11500_12000.fasta')

#Remove laboratory test strains

lab_strains <- c('GQ412744', 
                 'JN234411',
                 'KF154998',
                 'FJ959397',
                 'EF564174',
                 'HQ317918')

'%ni%' <- Negate('%in%')

meta <- meta %>% dplyr::filter(id %ni% lab_strains)

names(seq) <- gsub("\\..*","",names(seq))

seq <- seq[names(seq) %in% meta$id]

##HARD CODE: Rewrite FastaFile
write.fasta(seq, names = names(seq), file = 'ncbi_RABV_11500_12000_cleaned_2.fasta')

#WITH PARSER: 
#write.fasta(seq, names = names(seq), file = args$output_fasta)

##Rewrite Meta file without lab strains
write.table(meta, "/Volumes/@home/rabies/data/ncbi_cleaned.tab", sep="\t", row.names = FALSE)













