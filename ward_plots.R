#### Install & Load packages ####

install.packages(c("tidyverse",
                   "fingertipsR",
                   "cowplot",
                   "rtools",
                   "geojsonio"))

library(fingertipsR)
library(tidyverse)
library(cowplot)
library(geojsonio)

#### Download indicator data from Fingertips ####

# Get a list of indicators that are available at ward-level
# Produces a data frame of indicators that are available for wards
# Accesses Fingertips database, takes time to run. 
# Best to store the output as an object to save time.

ward_inds <- function(){
  t <- indicator_areatypes() %>%
       filter(AreaTypeID == 8) %>% # Area type 8 = wards
       pull(IndicatorID)
     
  i <- indicators() %>%
       filter(IndicatorID %in% t) %>%
       filter(!duplicated(IndicatorID)) %>%
       select(id = IndicatorID,
              name = IndicatorName)

  return(i)
}

i <- ward_inds()
     

#### Maps ####

#### Get/load geographic ward data ####
if(!file.exists("wards.Rdata")){
  wards <- geojson_read("https://opendata.arcgis.com/datasets/5fb8813978cc4e4892da4b57bcf4491f_3.geojson",
                        what = "sp") 
  save(wards, file = "wards.Rdata")
}else{
  load("wards.Rdata")  
}



#### Bar plots ####