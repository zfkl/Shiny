library(shiny)
library(leaflet)
library(RColorBrewer)

shinyUI(bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                sliderInput("range", "Building Prices", min(immo_df$VALEUR_BATIMENT), max(immo_df$VALEUR_BATIMENT),
                            value = range(immo_df$VALEUR_BATIMENT), step = 1000
                ),
                selectInput("colors", "Color Scheme",
                            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                ),
                checkboxInput("legend", "Show legend", TRUE)
            
  )
)
)
