#----------------------------------------------------
# Visualizer 1.0
# ui.R
#----------------------------------------------------


# load libraries
library(shiny)
library(leaflet)


# application UI
shinyUI(fluidPage(
  
  h2('Lombardia'), # title
  h3('air condition'), # subtitle
  
  mainPanel(leafletOutput('map', width='1200px', height='600px')), # map
  
  # additional info
  hr(),
  column(12, textOutput('smp')), # max timestamp
  column(12, textOutput('gen'))  # generation time
))
