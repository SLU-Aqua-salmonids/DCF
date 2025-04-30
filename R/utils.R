#' Get electro fishing site info
#'
#' @param river character Name of river
#' @param as_sf logical. If TRUE return sites as sf object. Default FALSE
#' @param site_list list of data frames. Default DCF::efish_sites
#'
#' @return
#' A data frame with information about sites in river. See [DCF::efish_sites]
#' @export
#'
#' @examples
#' sites <- dcf_known_efish_sites("Sävarån")
dcf_known_efish_sites <- function(river, as_sf = FALSE, site_list = DCF::efish_sites){

  if (!(river %in% names(site_list))){
    warning("River ", river, " not found in list. Returning NULL")
    return(NULL)
  }
  sites <- site_list[[river]]
  if (as_sf){
    if (requireNamespace("sf", quietly = TRUE)){
      sites <- dvfisk::sers_sites_sf |>
        dplyr::right_join(sites, by = dplyr::join_by(xkoorlok, ykoorlok))
    } else {
      warning("Package sf is required to return sites as sf object")
    }
  }
  return(sites)
}


#' Return catchment name for river
#'
#' This function returns the catchment name for a river. The catchment name is
#' from a data frame with the columns `rivername` and `haroname`. By default
#' the data frame is `DCF::riverinfo` that contains information about rivers
#' monitored in the DCF-program.
#'
#' @param river character vector with river names
#' @param rinfo data frame with columns `rivername` and `haroname`. Default DCF::riverinfo
#'
#' @returns
#' A character vector with catchment names for the rivers.
#' @export
#'
#' @examples
#' dcf_rivername2haroname(c("Emån", "Sävarån", "Vindelälven"))
#'
dcf_rivername2haroname <- function(river, rinfo = DCF::riverinfo){
  if (!all((river %in% rinfo$rivername))){
    warning("All rivers ", paste0(river, collapse = ", "), " must be in riverinfo. Returning NULL")
    return(NULL)
  }
  res <- unlist(sapply(river, function(x) {rinfo[rinfo$rivername == x, ]$haroname}))
  if (length(res) != length(river)){
    stop("Length of result should be equal to length of input")
  }
  return(res)
}
#

#' Return catchment number for river
#'
#' This function returns the catchment name for a river. The catchment name is
#' from a data frame with the columns `rivername` and `haroname`. By default
#' the data frame is `DCF::riverinfo` that contains information about rivers
#' monitored in the DCF-program.
#'
#' @param river character vector with river names
#' @param rinfo data frame with columns `rivername` and `haronr`. Default DCF::riverinfo
#'
#' @returns
#' A character vector with catchment names for the rivers.
#' @export
#'
#' @examples
#' dcf_rivername2haronr(c("Emån", "Sävarån", "Vindelälven"))
#'
dcf_rivername2haronr <- function(river, rinfo = DCF::riverinfo){
  if (!all((river %in% rinfo$rivername))){
    warning("All rivers ", paste0(river, collapse = ", "), " must be in riverinfo. Returning NULL")
    return(NULL)
  }
  res <- unlist(sapply(river, function(x) {rinfo[rinfo$rivername == x, ]$haronr}))
  if (length(res) != length(river)){
    stop("Length of result should be equal to length of input")
  }
  return(res)
}
