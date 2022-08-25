# random raster

library(terra)
library(geodata)

world = world(path=paste0(data_dir,"World_shp"))
ext=ext(90,135,-10,35)

# generate a random raster
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


