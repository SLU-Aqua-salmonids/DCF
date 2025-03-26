#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#library(dplyr)
#library(shiny)
#library(leaflet)
#library(sf)
#library(DCF)


#' dcf_efish_app: A Shiny app for displaying e-fishing data
#'
#' This app displays e-fishing data from known DCF efishing sites.
#' The primary use is to examine if all expected sites have been fished and
#' identify missing sites and also duplicates
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(DCF)
#' dcf_efish_app()
#' }
dcf_efish_app <- function() {
  current_year <- as.numeric(format(Sys.Date(), '%Y'))
  years <- c(current_year:(current_year - 10))
  groups <- c ("WGBAST", "WGNAS")

# Define UI for app ----------------------------------------------------------
ui <- shiny::fluidPage(

  # Application title
  shiny::titlePanel("Sers Fished Sites"),

  # Sidebar with a slider input for number of bins
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::selectInput("group", label = "Group:",
                  choices = groups, selected = "WGBAST"),
      shiny::selectInput("year", label = "Year:",
                  choices = years, selected = current_year),
      shiny::selectInput("river", label = "River:", choices = DCF::WGBAST_rivers),
      shiny::textOutput("dateStamp")
    ),

    # Show a plot of the generated distribution
    shiny::mainPanel(
      shiny::tabsetPanel(
        shiny::tabPanel("Overview",
                        shiny::tableOutput("yearTable")
               ),
        shiny::tabPanel("River Table",
                        shiny::tableOutput("riverFished")),
        shiny::tabPanel("River Map",
                        leaflet::leafletOutput("riverMap"))
      )
    )
  )
)

# Define server logic for output ------------------------------------------------
server <- function(input, output, session) {
  shiny::observe({
    if (input$group == "WGBAST") {
      rivers <- DCF::WGBAST_rivers
    } else if (input$group == "WGNAS") {
      rivers <- DCF::WGNAS_rivers
    }
    shiny::updateSelectInput(session,"river", choices = rivers)
  })

    output$yearTable <- shiny::renderTable({
      if (input$group == "WGBAST") {
        rivers <- DCF::WGBAST_rivers
      } else if (input$group == "WGNAS") {
        rivers <- DCF::WGNAS_rivers
      }
      sites <- efish_sites[rivers]
      status_table <- data.frame(River = rivers, Sites = NA, Done = 0)
      status_table$Sites <- sapply(1:length(rivers), function(x) {nrow(sites[[x]])})
      for (i in 1:length(rivers)) {
        d <- dcf_get_efish_data(river = rivers[i], year = as.numeric(input$year))# |>
#          filter(syfte == 'Nö-lax')
        done <- sum(!is.na(d$fiskedatum))
        status_table[i,]$Done <- done
      }
      status_table$Done <- as.integer(status_table$Done)
      return(status_table)
    })

    output$dateStamp <- shiny::renderText({
      latest_date <- sers_latest_regdatum(sers)
      return(paste0("Sers updated: ", latest_date))
    })

    output$riverFished <- shiny::renderTable({
      res <- dcf_get_efish_data(input$river, year = as.numeric(input$year)) |>
        dplyr::select(name, xkoorlok, ykoorlok, fiskedatum, syfte, lax0, lax,
               öring0, öring, antutfis)

      res$xkoorlok <- as.integer(res$xkoorlok)
      res$ykoorlok <- as.integer(res$ykoorlok)
      return(res)
    })

    output$riverMap <- leaflet::renderLeaflet({
      catch <- dcf_get_efish_data(input$river, year = as.numeric(input$year)) |>
        dplyr::mutate(status = if_else(is.na(fiskedatum), "not-fished", "fished"))
      icon_cols <- colorFactor(c("#ffb81c", "#ff585d"), domain = c("fished", "not-fished"))
      points <- dvfisk::sites_sf |>
        dplyr::right_join(catch, by = join_by(xkoorlok, ykoorlok))
      popup_text <-sprintf("<div><b>%s</b></br>0+: %s</br>>0+: %s</div>", points$lokal, points$lax0, points$lax)
      leaflet::leaflet(points) |>
        leaflet::addProviderTiles(leaflet::providers$OpenStreetMap, group = "Open Street Map") |> # options = providerTileOptions(noWrap = TRUE)
        leaflet::addProviderTiles(leaflet::providers$Esri.WorldImagery, group = "ESRI World Imagery") |>
        leaflet::addLayersControl(
          baseGroups = c("Open Street Map","ESRI World Imagery"),
          options = leaflet::layersControlOptions(collapsed = FALSE)) |>
        leaflet::addCircleMarkers(popup = popup_text, radius = 6, color = ~icon_cols(status))
    })

  }

# Run the application
shiny::shinyApp(ui = ui, server = server)
}
