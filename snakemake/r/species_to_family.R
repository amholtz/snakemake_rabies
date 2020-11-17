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

#download current table from home data folder
meta <- read.delim("/Volumes/@home/rabies/data/ncbi_cleaned.tab")

#create list of unique species names
host_sp <- meta %>% 
  select(host) %>% 
  group_by(host) %>% 
  unique()

#get family names for each species
x <- tax_name(host_sp$host, get = 'family', db = 'ncbi')

#get order names for each species
order<- tax_name(host_sp$host, get = 'order', 'family', db = 'ncbi')

#join family and order together
tax <- left_join(order, x, 'query')

#remove database columns
tax <- select(tax, -db.x, -db.y)

#rename query column to host for better joining with meta data
names(tax)[1] <- "host"

#join family and order with meta data on host column
new <- left_join(meta, tax, by = 'host')

#create new column for better organization keeping family names except
#for species that belong to order Chiroperta and Artiodactyla
new$mix <- ifelse(new$order == 'Chiroptera', "Chiroptera",
                  ifelse(new$order == 'Artiodactyla', "Artiodactyla",
                  new$family))

#create new tab delimited table WITHOUT row names!
write.table(new, "/Volumes/@home/rabies/data/ncbi_cleaned.tab", sep="\t", row.names = FALSE)







