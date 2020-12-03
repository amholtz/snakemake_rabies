################################################################
##        Getting and Adding Regional Data Information for Canada and the US
##
##  date: 23 November 2020
###############################################################

library(dplyr)
library(tidyr)
library(stringr)
library(data.table)

#This was downloaded from NCBI Virus, searched for Lyssavirus Rabies,
#Length 11500 and 12000, and filtered for North America

ncbi <- read.csv("data/meta_US_CA_locations.csv")

#Get just the years
ncbi$Collection_Date <- str_sub(ncbi$Collection_Date, start = 0, end = 4)

#split geolocation into many different columns
ncbi <- setDT(ncbi)[, paste0("Country", 1:2) := tstrsplit(Geo_Location, ":")]
ncbi <- setDT(ncbi)[, paste0("Region", 1:3) := tstrsplit(Country2, ",")]


canada <- dplyr::filter(ncbi, Country1 == "Canada")

canada <- canada %>% dplyr::select(Accession, Host, Collection_Date, Country1, Region3, Region1)

#remove region 2, and if region 3 is empty, replace it with region 3
canada$region <- ifelse(is.na(canada$Region3), canada$Region1, canada$Region3)

canada <- canada %>% dplyr::select(Accession, Host, Collection_Date, region)

#use abbreviations for all territories/provinces
canada$region <- str_replace(canada$region,"Quebec", "QC")
canada$region <- str_replace(canada$region,"Ontario", "ON")
canada$region <- str_replace(canada$region,"Nova Scotia", "NS")
canada$region <- str_replace(canada$region,"New Brunswick", "NB")
canada$region <- str_replace(canada$region,"Manitoba", "MB")
canada$region <- str_replace(canada$region,"British Columbia", "BC")
canada$region <- str_replace(canada$region,"Prince Edward Island", "PE")
canada$region <- str_replace(canada$region,"Saskatchewan", "SK")
canada$region <- str_replace(canada$region,"Alberta", "AB")
canada$region <- str_replace(canada$region,
                             "Newfoundland and Labrador", "NL")
canada$region <- str_replace(canada$region,"Northwest Territories", "NT")
canada$region <- str_replace(canada$region,"Northern Territories", "NT")
canada$region <- str_replace(canada$region,"Yukon", "YT")
canada$region <- str_replace(canada$region,"Nunavut", "NU")

us <- dplyr::filter(ncbi, Country1 == "USA")

#remove region 2, and if region 3 is empty, replace it with region 3
us$region <- ifelse(is.na(us$Region2), us$Region1,
                    ifelse(is.na(us$Region3), us$Region2, us$Region3))

us <- us %>% dplyr::select(Accession, Host, Collection_Date, region)

us$region <- str_replace(us$region,"Alabama", "AL")
us$region <- str_replace(us$region,"Alaska", "AK")
us$region <- str_replace(us$region,"New York", "NY")
us$region <- str_replace(us$region,"Pennsylvania", "PA")


ncbi_region <- bind_rows(us, canada)


ncbi <- dplyr::select(ncbi, Accession, Country1)

ncbi_region <- ncbi_region %>% 
  rename(id = Accession) %>% 
  rename(host = Host) %>% 
  rename(collection_date = Collection_Date) 

ncbi_region$region <- str_trim(ncbi_region$region)

### NOW TO PUT EVERYTHING TOGETHER

#Reading the ncbi_cleaned meta data that exists in the Data on Volumes
meta <- read.delim("/Volumes/@home/rabies/data/ncbi_cleaned.tab")

meta <- select(meta, -region)

#Lets remove everything in ncbi_region except id and region to make an easy join

ncbi_region <- dplyr::select(ncbi_region, id, region)

region <- left_join(meta, ncbi_region, by = "id")

write.table(region, "/Volumes/@home/rabies/data/ncbi_cleaned.tab", sep="\t", row.names = FALSE)
