library(terra)

bluetopotiles <- vect("~/Downloads/BlueTopo_Tile_Scheme_20241118_105559.gpkg")
bluetopotiles
ext <- ext(-69, -62.3, 16.6, 19.4)
bluetopotiles <- crop(bluetopotiles,ext)



# Destination folder for the downloaded files
destination_folder <- "~/Documents/GIS/Data/Raster/Bathymetry/Puerto Rico"

# Create the folder if it doesn't exist
if (!dir.exists(destination_folder)) {
  dir.create(destination_folder)
}

# Function to download a single file
download_file <- function(url) {
  file_name <- basename(url) # Extract the file name from the URL
  dest_file <- file.path(destination_folder, file_name) # Create the full path
  
  # Check if the file already exists
  if (file.exists(dest_file)) {
    message(paste("Skipping", file_name, "- already exists."))
  } else {
    message(paste("Downloading", file_name, "..."))
    download.file(url, destfile = dest_file, mode = "wb") # Download the file
    message(paste(file_name, "downloaded successfully."))
  }
}


url_list <- bluetopotiles$GeoTIFF_Link[!is.na(bluetopotiles$GeoTIFF_Link)]
# Download all files in the list
lapply(url_list, download_file)
