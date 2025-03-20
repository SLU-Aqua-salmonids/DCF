#' Get electro fishing site info
#'
#' @param river character Name of river
#' @param site_list list of data frames. Default DCFsers::efish_sites
#'
#' @return
#' A data frame with information about sites in river. See [DCFsers::efish_sites]
#' @export
#'
#' @examples
#' sites <- dcf_known_efish_sites("Sävarån")
dcf_known_efish_sites <- function(river, site_list = DCFsers::efish_sites){
  if (!(river %in% names(site_list))){
    warning("River ", river, " not found in list. Returning NULL")
    return(NULL)
  }
  return(DCFsers::efish_sites[[river]])
}


#' Return catchment name for river
#'
#' This function returns the catchment name for a river. The catchment name is
#' from a data frame with the columns `rivername` and `haroname`. By default
#' the data frame is `DCFsers::riverinfo` that contains information about rivers
#' monitored in the DCF-program.
#'
#' @param river character vector with river names
#' @param riverinfo data frame with columns `rivername` and `haroname`. Default DCFsers::riverinfo
#'
#' @returns
#' A character vector with catchment names for the rivers.
#' @export
#'
#' @examples
#' dcf_rivername2haroname(c("Emån", "Sävarån", "Vindelälven"))
#'
dcf_rivername2haroname <- function(river, riverinfo = DCFsers::riverinfo){
  rinfo <- DCFsers::riverinfo
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
#' the data frame is `DCFsers::riverinfo` that contains information about rivers
#' monitored in the DCF-program.
#'
#' @param river character vector with river names
#' @param riverinfo data frame with columns `rivername` and `haronr`. Default DCFsers::riverinfo
#'
#' @returns
#' A character vector with catchment names for the rivers.
#' @export
#'
#' @examples
#' dcf_rivername2haroname(c("Emån", "Sävarån", "Vindelälven"))
#'
dcf_rivername2haronr <- function(river, riverinfo = DCFsers::riverinfo){
  rinfo <- DCFsers::riverinfo
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
