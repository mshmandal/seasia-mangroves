# WORK IN PROGRESS


# load required libraries
library(terra)
library(geodata)
library(dplyr)

# main folder to save the downloaded data
data_dir = "D:/bigdata/"
ext = ext(90,135,-10,35)
################################################################################
# # GET WORLD MANGROVE WATCH DATA
################################################################################
world = world(path=paste0(data_dir,"World_shp"))
# because of large file increase the default time-out 
options(timeout = 1000); getOption('timeout')

# Make directory to download data
dir.create(paste0(data_dir,"GMW"))

# Download Global Mangrove Watch 2020 vector data: 
# https://data.unep-wcmc.org/datasets/45

# download.file(url = "https://wcmc.io/GMW_2020",
#               mode = "wb",
#               destfile = paste0(data_dir,"GMW","/","gmw.zip")
#               )
# unzip(zipfile = paste0(data_dir,"GMW","/","gmw.zip"),
#       exdir = paste0(data_dir,"GMW")
#      )

gmw2020 = vect(paste0(data_dir,"GMW","/","gmw_v3_2020_vec.shp"))
gmw2020 = crop(gmw2020,ext)

gmw2020 = simplifyGeom(gmw2020, tolerance=5, preserveTopology=TRUE, makeValid=TRUE)

################################################################################
# # GET IBTRACS data
################################################################################
noaa = "https://www.ncei.noaa.gov/data/"
ibtracs = "international-best-track-archive-for-climate-stewardship-ibtracs/"
#download.file(paste0(noaa,ibtracs,"v04r00/access/csv/ibtracs.ALL.list.v04r00.csv"),
#              mode = "wb",destfile = paste0(data_dir,"IBTRACS","/","ibtracs.csv"))

cyPath = read.csv(paste0(data_dir,"IBTRACS","/","ibtracs.csv"))
cyPath = cyPath[-c(1)]
cyPath$lat <- as.numeric(cyPath$LAT)
cyPath$lon <- as.numeric(cyPath$LON)

names(wp)
wp = cyPath %>% filter(BASIN=="WP") %>%
       filter(SEASON>2010)

wp = vect(wp,geom=c("lon","lat"),crs="EPSG:4326")


################################################################################
# Visualize
################################################################################
# get vector data
mycrs = "EPSG:3857"


gmw2020 = terra::crop(gmw2020,ext)

# make plot
library(raster)
r =raster(nrows=6000,ncols=2000,xmn=90,xmx=135,ymn=-10,ymx=35,crs="EPSG:4326",vals=NULL)

values(r)<- runif(n = ncell(r),min = -1,max = 1)


#r = project(rast(r),mycrs)
r = mask(rast(r),world)
plot(r)
plot(world,add=T)
plot(wp,add=T)