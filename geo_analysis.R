#set wd to abi
setwd("/Users/danberle/abi")

library(dplyr)
library(ggplot2)
library(magrittr)
library(readr)
library(lubridate)
library(sf)

#Read in sample geo data
sample_geo <- read_csv("br_sample_w_orders.csv")

#Create an sf dataframe 
sf_geo <- st_as_sf(sample_geo, coords = c("DELIVERY_LONGITUDE", "DELIVERY_LATITUDE"),
                   crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

#Create a distance matrix
dist.mat <- st_distance(sf_geo)

#Number of points within 100 meters
num.100 <- apply(dist.mat, 1, function(x) {
  sum(x < 100) - 1
})

#Number of points within 10 meters
num.10 <- apply(dist.mat, 1, function(x) {
  sum(x < 10) - 1
})

#Calculate the nearest difference
nn.dist <- apply(dist.mat, 1, function(x) {
  return(sort(x, partial = 2)[2])
})

# Get index for nearest distance
nn.index <- apply(dist.mat, 1, function(x) { order(x, decreasing=F)[2] })

#Put the data together
n.data <- sample_geo
colnames(n.data)[1:ncol(n.data)] <- 
  paste0("n.", colnames(n.data)[1:ncol(n.data)])

sample_geo2 <- data.frame(sample_geo,
                          n.data[nn.index, ],
                          n.distance = nn.dist,
                          radius100 = num.100,
                          radius10 = num.10)

#Create a table with POCs and their closest neighbor where that neighbor is within 10 meters
sample_geo3 <- sample_geo2 %>%
  select(COUNTRY:MAX_ORDER, n.ACCOUNT_ID, n.NAME, n.MIN_ORDER, n.MAX_ORDER, 
         n.DELIVERY_LATITUDE, n.DELIVERY_LONGITUDE,  n.distance, radius100, radius10
         ) %>%
  filter(DELIVERY_LATITUDE != 0) %>%
  filter(n.distance == 0) %>%
  filter(!is.na(MIN_ORDER)) %>%
  mutate(date_within = case_when(
    n.MIN_ORDER >= MIN_ORDER & n.MIN_ORDER <= MAX_ORDER ~ 1,
    n.MAX_ORDER >= MIN_ORDER & n.MIN_ORDER <= MAX_ORDER ~ 1
  ),
  interval1 = MIN_ORDER %--% MAX_ORDER,
  interval2 = n.MIN_ORDER %--% n.MAX_ORDER,
  overlap = interval1 %within% interval2
  )
