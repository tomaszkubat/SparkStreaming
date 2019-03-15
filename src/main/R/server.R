#----------------------------------------------------
# Visualizer 1.0
# server.R
#----------------------------------------------------


# load libraries
library(shiny)
library(leaflet)
library(rstudioapi)
library(dplyr)

# set working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))


# server logic
shinyServer(function(input, output) {
  
  # get timestamps
  genTmstmp <- as.character(format(Sys.time(), '%Y-%m-%d %H:%M:%S')) # current timestamp
  maxTmstmp <- as.character(read.csv(file='data/timestamp.csv/part-00000.csv', sep=',')[1,1]) # value
  
  # laod sensor data
  sensors <- read.csv(file='data/sensorsOut.csv/part-00000.csv', header=TRUE, sep=',') # data.frame
  sensors$Color <- case_when(
    sensors$State == "ok" ~ "green",
    sensors$State == "broken" ~ "black",
    sensors$State == "air pollution" ~ "red",
    TRUE ~ "white"
  )
  sensors$Radius <- case_when(
    sensors$State == "ok" ~ 1000,
    sensors$State == "broken" ~ 1000,
    sensors$State == "air pollution" ~ 1000 + ((sensors$Ratio-1)^0.5)*500,
    TRUE ~ 1000
  )
  sensors <- sensors[order(sensors$State, decreasing=TRUE),] # order data
  
  # map
  output$map <- leaflet::renderLeaflet({
    leaflet() %>% # preapare leaflet object
      addTiles() %>% 
      addCircles(
        data=sensors, # dataset
        lat=~CordsLat, lng=~CordsLng, color=~Color, radius=~Radius, group=~State, label=~Label, # dynamic params
        stroke=FALSE # static params
      ) %>%
      addLayersControl(
        overlayGroups = sort(unique(sensors$State)),
        options=layersControlOptions(collapsed=FALSE)  
      )
      
  })
  
  # additional info
  output$smp <- renderText({paste("max timestamp:", maxTmstmp)}) # last timestamp
  output$gen <- renderText({paste("generated:", genTmstmp)}) # generation time
  
})
