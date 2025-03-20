
##' Return the spatial point of all (DCF) electrofishing point for a river
##'
##' @param river character string with river name
##' @param sites dataframe with site info. Must have cols xkoorlok and ykoorlok in SERS-format.
##'
##' @return a SpatialPointsDataFrame with elecrofishing sites
##' @export
##'
##'
##' @examples
##' foo <- sers_sites_sp("Emån")
##' foo
##'
# sers_sites_sp <- function(river, sites = DCFsers::dcf_known_efish_sites(river)) {
#   .Deprecated("sers_sites_sf")
#   coords <- sites[,c("ykoorlok", "xkoorlok")] * 10
#   if (requireNamespace("sp", quietly = TRUE) &
#       requireNamespace("rgdal", quietly = TRUE)) {
#     points <- sp::spTransform(
#       sp::SpatialPointsDataFrame(coords,
#                                  data = sites,
#                                  proj4string = sp::CRS("+init=epsg:3021")),
#       CRSobj = sp::CRS("+init=epsg:4326")
#     )
#     return(points)
#   } else {
#     warning("missing packages sp and rgdal, returning RT90 coordinates")
#     return(coords)
#   }
# }


#' Return the simple feature collection (sf points) of all (DCF) electrofishing point for a river
#'
#' @param  con a database connection to sers (see sers_connect())
#' @param river character string with river name
#' @param sites dataframe with site info. Must have cols xkoorlok and ykoorlok in SERS-format.
#'
#' @return a SpatialPointsDataFrame with elecrofishing sites
#' @export
#'
#' @examples
#' \dontrun{
#' sers <- sers_connect()
#' foo <- sers_sites_sf(sers, "Emån")
#' foo
#' }
#'
sers_sites_sf <- function(con, river, sites = DCFsers::dcf_known_efish_sites(river)) {
    if (!requireNamespace("sf", quietly = TRUE)) {
    stop("missing packages sf")
  }
    pkeys <- get_pkeys(river, sites = sites)
  query <-
    paste0("SELECT vdragnam, lokalnam, hoh, haronr, xkoorlok, ykoorlok, geom FROM sers.lokaler a WHERE ", pkeys)
  res <- sf::st_read(con, query = query)
  return(res)
}

