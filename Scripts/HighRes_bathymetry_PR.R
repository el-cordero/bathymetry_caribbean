# load in libraries
library(terra)

# List of bathymetry data for PR
bluetopo_files <- list.files(
  path = '~/Documents/GIS/Data/Raster/Bathymetry/Puerto Rico',
  full.names = TRUE,
  recursive = TRUE
)

# Set the CRS to NAD83 - a few of the raster are in UTM 19N
crs <- "EPSG:4269"

# Develop a code to extract the elevation layer from each raster
# and to collect the lowest resolution
bluetopo <- c()
lowest_res <- 100
for (raster in bluetopo_files){
  s <- rast(raster)           # import raster file from list
  t <- s$Elevation            # elevation layer
  t <- project(t, crs)        # reproject
  bluetopo <- c(bluetopo,t)   # add to list
  
  # get the lowest resolution
  if (res(t)[1] < lowest_res){
    lowest_res <- res(t)[1]
  }
  
  rm(t,s)     # remove temp files
}

# resample the rasters to the same (lowest) resolution
for (i in 1:length(bluetopo)){
  r <- rast(crs=crs(bluetopo[[i]]), 
            ext=ext(bluetopo[[i]]), 
            res=lowest_res)
  bluetopo[[i]] <- resample(bluetopo[[i]],r)
}

# merge the rasters into a mosaic
sprc <- sprc(bluetopo) # mosaic
bluetopo_mosaic <- mosaic(sprc)

writeRaster(bluetopo_mosaic, '~/Documents/GIS/Data/Raster/Bathymetry/Puerto Rico/hr_bathy_PR.tif',
            overwrite=TRUE)
rm(bluetopo,bluetopo_mosaic)
tmpFiles(remove=TRUE)
