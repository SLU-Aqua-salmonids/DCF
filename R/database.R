#' Get electrofishing data for a river for one species one year
#'
#' @param river character string with name of river.
#' @param year numeric year to query or the string "all". Default current year
#' @param year2 optional numeric to return results between year and year2
#' @param species character string indication what species to query. Default "Lax".
#' @param sites a data frame with xkoorlok and ykoorlok
#'
#' @return
#' Return a data frame with electro fishing results. If "fiskedat" is NA the site was not
#' fished in the time period.
#' @export
#'
#' @examples
#' \dontrun{
#' res <- dcf_get_efish_data("Vindelälven", species = "Lax", year= 2018)
#' head(res)
#' }
dcf_get_efish_data <- function(river,
                               year = as.numeric(format(Sys.Date(), "%Y")),
                               year2 = NULL,
                               wanted_sites = dcf_known_efish_sites(river)) {
  haro <- dcf_rivername2haronr(river)
  if (length(haro) != 1) {
    stop(sprintf("River %s not found in SERS", river))
  }
  if (is.numeric(year) & is.null(year2)) {
    start_date <- sprintf("%d-01-01", year)
    stop_date <- sprintf("%d-12-31", year)
  } else if (is.numeric(year) & is.numeric(year2)) {
    start_date <- sprintf("%d-01-01", year)
    stop_date <- sprintf("%d-12-31", year2)
  } else if (is.character(year) & year == "all") {
    start_date <- "1900-01-01"
    stop_date <- format(Sys.Date(), "%Y-%m-%d")
  } else {
    stop('year must numeric or the string "all"')
  }

  fished_sites <- dvfisk::sers_vix_rapport(haroNr = haro,
                                           startdatum = start_date,
                                           slutdatum = stop_date)
  if (length(fished_sites) == 0) {
    warning("No data returned from SERS")
    return(NULL)
  }
  xcoords <- wanted_sites$xkoorlok
  ycoords <- wanted_sites$ykoorlok

  fished_sites <- fished_sites |>
    dplyr::filter(xkoorlok %in% xcoords & ykoorlok %in% ycoords) |>
    dplyr::select(
      haronr = harO_NR,
      vattendrag,
      lokal,
      xkoorlok,
      ykoorlok,
      fiskedatum,
      syfte,
      hoh,
      lax0,
      lax,
      lax0ber,
      laxber,
      lax0pval,
      laxpval,
      öring0,
      öring,
      örin0ber,
      öringber,
      öri0pval,
      örinpval,
      antutfis,
      metod,
      bredd,
      langd,
      fished_area = area
    )

  res <- wanted_sites |>
    dplyr::left_join(fished_sites, by = dplyr::join_by(xkoorlok, ykoorlok)) |>
    dplyr::mutate(lokal = if_else(is.na(lokal), name, lokal)) |> # Use "name" (from built-in data) if "lokal" (from SERS) is missing
    dplyr::select(-name) |>
    dplyr::arrange(hoh)

  return(res)
}

#' Latest SERS update date
#'
#' @param con a valid connection to SERS
#'
#' @return
#' The latest registration date in table sers.elfisken
#' @export
#'
#' @examples
#' \dontrun{
#' con <- sers_connect()
#' latest_date <- sers_latest_regdatum(con)
#' }
sers_latest_regdatum <- function(con) {
  .Deprecated("", msg = "Function is deprecated and will be removed in the future. Returns current date")
#  if (!DBI::dbIsValid(con)) {
#    stop("invalid connection parameter")
#  }
#  res <- DBI::dbGetQuery(conn = con, "select max(regdatum) as d from sers.elfisken")
  return(Sys.Date())
  }
