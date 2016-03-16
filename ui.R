
library(shiny)
library(leaflet)
library(RColorBrewer)
library(RJSONIO)
library(htmltools)



shinyUI(bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
    absolutePanel( id = "controls", class = "panel panel-default", fixed = TRUE,
                   draggable = TRUE, top = 10, right = "auto", left = "auto", bottom = "auto",
                   width = 200, height = "auto", style = 'opacity:0.7',
             
                
              
    plotOutput("barplot_main_city", height = 200, width =150),

    radioButtons("radio", label = "Candidate",
                 choices = list("Clinton"= "hilary clinton",
                                "Trump"= "trump"), selected = "hilary clinton"),
    checkboxInput("legend", "Show Legend",TRUE)             
      
    
    )
  )
)

