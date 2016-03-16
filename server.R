#I playes with some Ville de Montreal open data about real estate
#the app is interactive
#with a slider bar, you can select only the range of prices you want
#just for fun, I added a color bar so that you can select your palette

library(shiny)
library(leaflet)
library(RColorBrewer)

immo_df = read.csv("../sause01direction01directiondonneesouvertesbatimentsvacantsbatimentsvacantsvm2015.csv")
shinyServer(function(input, output) {
  
  # Reactive expression for the price range selected by user
  priceRange <- reactive({
    immo_df[immo_df$VALEUR_BATIMENT>= input$range[1] & immo_df$VALEUR_BATIMENT <= input$range[2],]
  })
  
  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  colorpal <- reactive({
    colorNumeric(input$colors, immo_df$VALEUR_BATIMENT)
  })
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(immo_df) %>% addTiles() %>%
      fitBounds(~min(LONGITUDE), ~min(LATITUDE), ~max(LONGITUDE), ~max(LATITUDE))
  })
  
  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    pal <- colorpal()
    
    leafletProxy("map", data = priceRange()) %>%
      clearShapes() %>%
      addCircles(radius = 120, weight = 1, color = "#777777",
                 fillColor = pal(immo_df$VALEUR_BATIMENT), fillOpacity = 0.7, popup = paste(immo_df$VALEUR_BATIMENT)
      )
  })
  
  # Use a separate observer to recreate the legend as needed.
  observe({
    proxy <- leafletProxy("map", data = immo_df)
    
    # Remove any existing legend, and only if the legend is
    # enabled, create a new one.
    proxy %>% clearControls()
    if (input$legend) {
      pal <- colorpal()
      proxy %>% addLegend(position = "bottomright",
                          pal = pal, values = ~VALEUR_BATIMENT
      )
    }
  })
}
)
