% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{dcf_known_efish_sites}
\alias{dcf_known_efish_sites}
\title{Get electro fishing site info}
\usage{
dcf_known_efish_sites(river, as_sf = FALSE, site_list = DCF::efish_sites)
}
\arguments{
\item{river}{character Name of river}

\item{as_sf}{logical. If TRUE return sites as sf object. Default FALSE}

\item{site_list}{list of data frames. Default DCF::efish_sites}
}
\value{
A data frame with information about sites in river. See [DCF::efish_sites]
}
\description{
Get electro fishing site info
}
\examples{
sites <- dcf_known_efish_sites("Sävarån")
}
