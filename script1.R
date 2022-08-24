# WORK IN PROGRESS


# load required libraries
library(terra)
library(geodata)
library(dplyr)

# main folder to save the downloaded data
data_dir = "D:/bigdata/"
dir.create(paste0(data_dir))
dir.create(paste0(data_dir,"GMW"))
dir.create(paste0(data_dir,"world_shp"))
dir.create(paste0(data_dir,"IBTRACS"))

# because of large file increase the default time-out 
options(timeout = 1000); getOption('timeout')

################################################################################
# # GET WORLD MANGROVE WATCH DATA
################################################################################
# define study extent
ext = ext(90,135,-10,35)
world = world(path=paste0(data_dir,"World_shp"))

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
# download.file(paste0(noaa,ibtracs,"v04r00/access/csv/ibtracs.ALL.list.v04r00.csv"),
#               mode = "wb",destfile = paste0(data_dir,"IBTRACS","/","ibtracs.csv"))

cyPath = read.csv(paste0(data_dir,"IBTRACS","/","ibtracs.csv"))
cyPath = cyPath[-c(1),]
cyPath$lat <- as.numeric(cyPath$LAT)
cyPath$lon <- as.numeric(cyPath$LON)

# filter by basin and year


wp = vect(wp,geom=c("lon","lat"),crs="EPSG:4326")


################################################################################
# Visualize
################################################################################
# get vector data
mycrs = "EPSG:3857"
glb_elv = elevation_global(res = 10,path=paste0(data_dir,"world_shp"))

gmw2020 = terra::crop(gmw2020,ext)

# Create a raster in the study extent
library(raster)
r <- raster(nrows=6000,
          ncols=2000,
          xmn=90,
          xmx=135,
          ymn=-10,
          ymx=35,
          crs="EPSG:4326",
          vals=NULL
          )
values(r)<- runif(n = ncell(r),min = -1,max = 1)
r = mask(rast(r),world)

#r = project(rast(r),mycrs)
help(plot,package = terra)



