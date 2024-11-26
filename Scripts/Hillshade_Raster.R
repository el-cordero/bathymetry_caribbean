library(terra)

bathy <- rast('~/Documents/GIS/Data/Raster/Bathymetry/Puerto Rico/hr_bathy_PR.tif')

ext <- ext(c(-67.3, -66.7, 17.7, 18.1))
bathy <- crop(bathy,ext)

r <- rast(crs=crs(bathy), ext=ext(bathy), res=2*res(bathy))
bathy <- resample(bathy,r)

sl <- terrain(bathy, "slope") 
asp <- terrain(bathy, "aspect")
hs <- shade(sl, asp, normalize = FALSE)


