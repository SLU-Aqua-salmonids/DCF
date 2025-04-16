#library(readxl)
## Script that creates data that should be installed as package data. Run this script
## to save data as .rda in ../data
## All data should be documented in ../R/package_data.R
if (requireNamespace("readxl", quietly = TRUE) &&
    requireNamespace("usethis", quietly = TRUE)) {
  message("readxl and usethis are available")
} else {
  stop("readxl and usethis packages are required to run this script.")
})

WGBAST_rivers <- readxl::excel_sheets("data-raw/WGBAST_sites.xlsx")
WGBAST_sites <- lapply(WGBAST_rivers, function(r) {
  res <-
    as.data.frame(readxl::read_excel("data-raw/WGBAST_sites.xlsx", sheet = r))
  res$used <- as.logical(res$used)
  return(res)
})
names(WGBAST_sites) <- WGBAST_rivers

#
WGNAS_rivers <- readxl::excel_sheets("data-raw/WGNAS_sites.xlsx")
WGNAS_sites <- lapply(WGNAS_rivers, function(r) {
  res <-
    as.data.frame(readxl::read_excel("data-raw/WGNAS_sites.xlsx", sheet = r))
  #  res$used <- as.logical(res$used)
  return(res)
})
names(WGNAS_sites) <- WGNAS_rivers
#
riverinfo <- readxl::read_excel("data-raw/riverinfo.xlsx")
#
efish_sites <- c(WGBAST_sites, WGNAS_sites)
usethis::use_data(WGBAST_rivers, compress = "xz", overwrite = TRUE)
usethis::use_data(WGNAS_rivers, compress = "xz", overwrite = TRUE)
usethis::use_data(efish_sites, compress = "xz", overwrite = TRUE)
usethis::use_data(riverinfo, compress = "xz", overwrite = TRUE)
