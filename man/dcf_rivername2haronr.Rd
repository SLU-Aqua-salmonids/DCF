% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{dcf_rivername2haronr}
\alias{dcf_rivername2haronr}
\title{Return catchment number for river}
\usage{
dcf_rivername2haronr(river, rinfo = DCF::riverinfo)
}
\arguments{
\item{river}{character vector with river names}

\item{rinfo}{data frame with columns `rivername` and `haronr`. Default DCF::riverinfo}
}
\value{
A character vector with catchment names for the rivers.
}
\description{
This function returns the catchment name for a river. The catchment name is
from a data frame with the columns `rivername` and `haroname`. By default
the data frame is `DCF::riverinfo` that contains information about rivers
monitored in the DCF-program.
}
\examples{
dcf_rivername2haronr(c("Emån", "Sävarån", "Vindelälven"))

}
