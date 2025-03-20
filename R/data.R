
# This files contains documentation for the exported data. No functions here.
#
#' Electofishing sites monitored in the DCF-program (WGBAST and WGNAS)
#'
#' Dataset DCFsers::efish_sites contains information about all electrofishing
#' sites monitored in the DCF-program. Xkoorlok and ykoorlok is the primary key
#' to find a unique site in SERS. `DCFsers::WGBAST_rivers` and
#' `DCFsers::WGNAS_rivers` are character vectors with rivers monitored by WG.
#' These vectors can, for example, be used to loop do some processing for all
#' rivers for a working group.
#'
#' @format WGBAST_rivers: A vector of  names of Swedish WGBAST rivers. The names can be used to select data from
#' `efish_sites`.
#'
#' @format WGNAS_rivers: A vector of  names of Swedish WGNAS rivers. The names can be used to select data from
#' `efish_sites`.
#'
#' @format efish_sites: A list of data frames, one for each river. Each item have is named after a river.
#'    Each data frame have the variables:
#' \describe{
#'   \item{name}{site name}
#'   \item{xkoorlok}{RT90 X coordinate / 10 Used as primary key in SERS}
#'   \item{xkoorlok}{RT90 Y coordinate / 10 Used as primary key in SERS}
#'   \item{section}{Name of section (blank if river is not divided in sections)}
#'   \item{area}{Estimated production area in hektar (per section if the river is divided)}
#'   \item{used}{logical Indicates if site is used in working group estimations}
#'   \item{since}{numerical First year site should be used in estimations. Zero = used since start}
#'
#' }
#' @source \url{https://www.slu.se/institutioner/akvatiska-resurser/databaser/elfiskeregistret/}
#' @source \url{https://www.ices.dk/community/groups/Pages/WGBAST.aspx}
#' @source \url{https://www.ices.dk/community/groups/Pages/WGNAS.aspx}
"efish_sites"

#' @rdname efish_sites
"WGBAST_rivers"

#' @rdname efish_sites
"WGNAS_rivers"
#
#' River information
#'
#' @format riverinfo: A data frame with information about rivers monitored in the DCF-program. Used to translate river names to catchment names.
#' \describe{
#'  \item{river}{River name}
#'  \item{haroname}{Catchment name}
#'  \item{haronr}{Catchment number}
#'  }
"riverinfo"
