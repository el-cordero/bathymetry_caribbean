library(terra)

# Define the directory containing the files
directory_path <- "/Users/ec/Documents/GIS/Data/Porras/SIMULACIONES_FRICCION_CONSTANTE/"

# List all files ending with '_5m.nc'
nc_files <- list.files(
  path = directory_path,
  pattern = "_5m\\.nc$", # Regex pattern to match '_5m.nc'
  full.names = TRUE,      # Include full file paths
  recursive = TRUE       # Search in all subdirectories
)

# Develop a code to extract the elevation layer from each raster
# and to collect the lowest resolution
bathys <- c()
for (raster in nc_files){
  s <- rast(raster, subds = "original_bathy")           # import raster file from list
  
  # some rasters have no data (0 res)
  if (res(s)[1] > 0){ 
    bathys <- c(bathys,s)   # add to list
  }
  
  rm(s)     # remove temp files
}

# merge the rasters
sprc <- sprc(bathys) # mosaic
bathymetry <- mosaic(sprc, fun='first')

writeRaster(bathymetry, '~/Documents/GIS/Data/Raster/Bathymetry/Puerto Rico/lr_bathy_PR.tif',
            overwrite=TRUE)

tmpFiles(remove=TRUE)