# File name: pointdata-polygon
# Author: Noel Dempsey
# Date: 24 Nov 2018

# This script provides an example of how to match longitude/latitude
# point data to geographies and polygons in shapefiles - in this case 2017 
# Westminster Parliamentary constituency boundaries in Great Britain.

# To follow the example you will need:

# 1. A copy of DFT's 'Accident' road safety data for 2017, which should be
# stored as 'accidents_2017.csv" in your project directory. This data can be
# found here:

# https://data.gov.uk/dataset/cb7ae6f0-4be6-4935-9277-47e5ce24a11f/road-safety-data

# 2. Boundary data and shapefile for 2017 Westminster Parliamentary 
# constituency boundaries in Great Britain stored in your project
# directory. This data can be found here:

# http://geoportal.statistics.gov.uk/datasets/westminster-parliamentary-constituencies-december-2017-full-extent-boundaries-in-great-britain

# Problem overiew -------------------------------------------------------------

# The UK's Department of Transport publish data on every road traffic
# accident resulting in personal injury in Great Britain. The accident data file
# contains variables such as the time of accident, severity, number of vehicles
# involved as well as the longitude/latitude coordinates of where the accident
# happened. The data doesn't contain information on our geography of interest: 
# Parliamentary constituencies.
# 
# By matching the longitude/latitude coordinates of each accident to the
# constituency polygons in our shapefile we can perform analysis
# on accidents per Parliamentary constituency.

# Imports ---------------------------------------------------------------------

library(dplyr)
library(stringr)
library(data.table)
library(rgdal)
library(spatialEco)

# Main ------------------------------------------------------------------------

# Load shapefile
dir_map <- getwd() # The project directory
fil_map <- str_c("Westminster_Parliamentary_Constituencies_December_2017_Full",
                 "_Extent_Boundaries_in_Great_Britain")
pcon_map <- readOGR(dsn = dir_map, layer = fil_map)

# Set Coordinate Reference System
crs <- "+init=epsg:4326"

# Change shapefile CRS
pcon_map <- spTransform(pcon_map, CRS(crs))

# Load dataset and duplicate
acc_data <- fread("accidents_2017.csv")
acc_copy <- acc_data

# Longitude and latitude variables to numeric
acc_copy$Longitude <- as.numeric(acc_copy$Longitude)
acc_copy$Latitude  <- as.numeric(acc_copy$Latitude)

# SpatialPointsDataFrames do not not accept coordinates with missing data,
# select longitude, latitude and accident index variable from dataset 
# and remove NA values
acc_copy   <- filter(acc_copy, !is.na(Longitude) | !is.na(Latitude))
acc_index  <- select(acc_copy, Accident_Index)
acc_coords <- select(acc_copy, Longitude, Latitude)

# Create SpatialPointsDataFrame
acc_spdf   <- SpatialPointsDataFrame(coords = acc_coords,
                                     data   = acc_index)

# Set CRS to match shapefile
proj4string(acc_spdf) <- CRS(crs)  

# Intersect coordinates with shapefile polygons 
acc_spdf <- point.in.poly(acc_spdf, pcon_map)

# Convert back to dataframe
acc_spdf <- as.data.frame(acc_spdf)

# Join with original dataset
acc_data <- left_join(acc_data, acc_spdf, by = "Accident_Index")

# Clean dataset
acc_data <- select(acc_data, -c(bng_e, bng_n, long, lat, objectid,
                                st_areasha, st_lengths, coords.x1,
                                coords.x2))