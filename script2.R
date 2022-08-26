# random raster

library(terra)
library(geodata)
data_dir = "D:/bigdata/"

# world shape file and elevation map
world = world(path=paste0(data_dir,"World_shp"))
glb_elv = elevation_global(res = 10,path=paste0(data_dir,"world_shp"))

#cyclone data
cyPath = read.csv(paste0(data_dir,"IBTRACS","/","ibtracs.csv"))
cyPath = cyPath[-c(1),]
cyPath$lat <- as.numeric(cyPath$LAT)
cyPath$lon <- as.numeric(cyPath$LON)
ext=ext(90,135,-10,35)
#---------------------------------------
# Elevation
#---------------------------------------
wp = cyPath %>% filter(BASIN=="WP") %>%
  filter(SEASON>2000) %>% 
  filter(USA_SSHS>0)

plot(crop(glb_elv,ext),breaks=c(0,100,500,1000,Inf),col=rainbow(5),grid=TRUE,type="interval")
plot(crop(world,ext),border="black",lwd=2,add=T)
plot(vect(wp),col=wp$USA_SSHS,add=T)

#---------------------------------------
# generate a random raster
#---------------------------------------
r = rast(resolution=1, 
     xmin =90,
     xmax=135,
     ymin=-10,
     ymax=35)
values(r) <- rep(1:ncell(r))

plot(mask(r,world),
     #type="interval",
     col=c("yellow","red","orange","yellow"),
     legend=FALSE,
     grid=TRUE
     )
plot(crop(world,ext),add=T)

#---------------------------------------
# Cyclone map
#---------------------------------------
library(prettymapr)
wp = cyPath %>% filter(BASIN=="WP") %>%
  filter(SEASON>2000) %>% 
  filter(USA_SSHS>0)
plot(glb_elv,ext=ext(60,180,-20,60),type="interval",col=rev(grey(0:4/4)),legen=F)
plot(world,add=T)
plot(vect(wp),col=wp$NUMBER,add=T,legend=T)
addnortharrow()
addscalebar()

#---------------------------------------
# Mangrove map
#---------------------------------------
library(sf)
dir = "D:/bigdata/GMW-all_2020_v3.0"

dir_list = list.files(pattern =c("N0\\d{1}E11\\d{1}"),path = dir,recursive = T,full.names = T)

dir_list
r = lapply(dir_list, rast)

r_moaic = do.call(mosaic,r)

plot(r_moaic,col="red")
