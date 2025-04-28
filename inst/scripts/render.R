library(dplyr)
library(DCF)

## This script renders the yearly report for all rivers defined in the DCF package.
## Use asis or modify to suit your needs.

## CONFIG: choose the year to render reports for,
year <- 2024
## CONFIG: choose the output directory
out_dir <- "render_output"


## Fetch the Rmarkdown template from the package and store in a temprorary file
my_template <- tempfile(fileext = ".Rmd")
if (!file.exists(my_template)) {
  rmarkdown::draft(my_template,
                   template = "river-yearly-report",
                   package = "DCF",
                   edit = FALSE)
}


if (!dir.exists(out_dir)) {
  dir.create(out_dir)
}

## Create reports for all rivers defined as WGBAST rivers
for (r in DCF::WGBAST_rivers) {
#  for (r in "Åbyälven") {
    output_name <- paste0(r, year, '.pdf')
  rmarkdown::render(my_template,
                    output_file = output_name,
                    output_dir = out_dir,
                    output_format="pdf_document",
                    envir = new.env(),
                    params = list(river = r,
                                  year = year))
}

unlink(my_template) # Remove the temporary file
