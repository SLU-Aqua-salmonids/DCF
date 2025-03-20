
#' Connect to the SERS database
#'
#' @param dbname Name of the database containing SERS (default = fishdb)
#' @param host Name or ip-number of host with database
#' @param port database port number
#' @param user database user
#' @param password  database password
#' @param use_latin1 set to TRUE if the client uses Latin1 (default = FALSE)
#'
#' @return a connection object
#' @export
#'
#' @examples
#' \dontrun{
#' sers <- sers_connect()
#' res <- dcf_get_efish_data(sers, "Vindelälven", species = "Lax", year = 2018)
#'}
#'
sers_connect <- function(dbname="fishdb", host="193.10.96.167", port=5432,
             user="readonly", password="readonly", use_latin1 = FALSE) {
  .Deprecated("", msg = "Function is deprecated and will be removed in the future. Returns empty string")

  # con <- DBI::dbConnect(
  #   RPostgres::Postgres(), dbname=dbname, host=host, port=port,
  #   user=user, password=password)
  # if (use_latin1) {
  #     DBI::dbExecute(con, "SET client_encoding = 'windows-1252'");
  # }
  return("")
}

#
#' Construct a string suitable to use in a where clause to select DCF sites for one river.
#'
#' @param river name of the river to construct a where clause for
#' @param tabe_prefix a string used as a table prefix (default = ".a")
#' @param sites a data frame with xkoorlok and ykoorlok
#'
#' @return a character string with primary keys for a specific river
#'
#' @examples
#' pkeys <- get_pkeys("Rickleån")
#' @export
get_pkeys <- function(river, table_prefix = "a.",
                      sites = DCFsers::dcf_known_efish_sites(river)) {
  pkeys <- paste(
    sprintf("(%sxkoorlok = %d AND %sykoorlok = %d)",
            table_prefix,
            sites$xkoorlok,
            table_prefix,
            sites$ykoorlok),
    collapse = " OR ")
  return(pkeys)
}


#' Get electrofishing data for a river for one species one year
#'
#' @param con a valid database connection to the SERS database
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
                              wanted_sites = DCFsers::dcf_known_efish_sites(river)) {
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
  # pkeys_sql <- DCFsers::get_pkeys(river, sites = sites)
  # sql <-  sprintf(
  #   "SELECT a.vdragnam, a.lokalnam, a.xkoorlok, a.ykoorlok, a.hoh, b.fiskedat, b.area, b.bredd,
  # b.lokalbre, b.langd, c.fiskart, c.oplus, c.storfisk, b.antutfis, b.metod, b.ansvarig, b.syfte
  # FROM sers.lokaler a
  # LEFT JOIN sers.elfisken b ON a.xkoorlok = b.xkoorlok AND a.ykoorlok = b.ykoorlok AND
  #   b.fiskedat >= %d0101 AND b.fiskedat <= %d1231
  # LEFT JOIN sers.fangster c ON b.xkoorlok = c.xkoorlok AND
  #   b.ykoorlok = c.ykoorlok AND b.fiskedat = c.fiskedat AND
  #   c.fiskart = '%s'
  # WHERE (%s)",
  #   start_year, stop_year, species, pkeys_sql)
  # res <- DBI::dbGetQuery(con, sql)
  # If no fish are caught at a site "fiskart" will b NA. In those cases set "oplus" and "storfisk" to 0
  # if (any(is.na(res$fiskart))) {
  #  res[is.na(res$fiskart),]$oplus <- 0
  #  res[is.na(res$fiskart),]$storfisk <- 0
  #  res[is.na(res$fiskart),]$fiskart <- species
  # }
  #known_sites <- dcf_known_efish_sites(river)
  xcoords <- wanted_sites$xkoorlok
  ycoords <- wanted_sites$ykoorlok

  fished_sites <- dvfisk::sers_vix_rapport(haroNr = haro,
                                       startdatum = start_date,
                                       slutdatum = stop_date)
  if (length(fished_sites) == 0) {
    warning("No data returned from SERS")
    return(NULL)
  }
  fished_sites <- fished_sites |>
    dplyr::filter(xkoorlok %in% xcoords & ykoorlok %in% ycoords) |>
    dplyr::select(haronr = harO_NR, vattendrag, lokal, xkoorlok, ykoorlok,fiskedatum,
                  syfte, hoh, lax0, lax, lax0ber, laxber, lax0pval, laxpval,
                  öring0, öring, örin0ber, öringber, öri0pval, örinpval,
                  antutfis, metod, bredd, langd, fished_area = area)

  res <- wanted_sites |>
    dplyr::left_join(fished_sites, by = dplyr::join_by(xkoorlok, ykoorlok)) |>
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
