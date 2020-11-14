################################################################
##        Get Family Name for Species in Metadata table
##
##  date: 12 November 2020
###############################################################


library(dplyr)
library(tidyr)
library(taxize)

## Preparing environment
rm(list=ls())

meta <- read.delim("/Volumes/@home/rabies/data/ncbi_cleaned.tab")

host_sp <- meta %>% 
  select(host) %>% 
  group_by(host) %>% 
  unique()

x<- tax_name(host_sp$host, get = 'family', db = 'ncbi')
family <- select(x, -db)
names(family)[1] <- "host"


new <- left_join(meta, family, by = 'host')


write.table(new, "/Volumes/@home/rabies/data/ncbi_cleaned.tab", sep="\t")
#revert back
#write.table(meta, "/Volumes/@home/rabies/data/ncbi_cleaned.tab", sep="\t")






