# pointdata-polygon

This script provides an example of how to match longitude/latitude
point data to geographies and polygons in shapefiles - in this case 2017 
Westminster Parliamentary constituency boundaries in Great Britain.

To follow the example you will need:

1. A copy of DFT's 'Accident' road safety data for 2017, which should be
stored as 'accidents_2017.csv" in your project directory. This data can be
found here:

https://data.gov.uk/dataset/cb7ae6f0-4be6-4935-9277-47e5ce24a11f/road-safety-data

2. Boundary data and shapefile for 2017 Westminster Parliamentary 
constituency boundaries in Great Britain stored in your project
directory. This data can be found here:

http://geoportal.statistics.gov.uk/datasets/westminster-parliamentary-constituencies-december-2017-full-extent-boundaries-in-great-britain

# Problem overiew 

The UK's Department of Transport publish data on every road traffic
accident resulting in personal injury in Great Britain. The accident data file
contains variables such as the time of accident, severity, number of vehicles
involved as well as the longitude/latitude coordinates of where the accident
happened. The data doesn't contain information on our geography of interest: 
Parliamentary constituencies.
 
By matching the longitude/latitude coordinates of each accident to the
constituency polygons in our shapefile we can perform analysis
on accidents per Parliamentary constituency.
