# Install related packages 
#ui

if (!require("shiny")) {
  install.packages("shiny")
  library(shiny)
}
if (!require("shinyWidgets")) {
  install.packages("shinyWidgets")
  library(shinyWidgets)
}
if (!require("shinythemes")) {
  install.packages("shinythemes")
  library(shinythemes)
}
if (!require("leaflet")) {
  install.packages("leaflet")
  library(leaflet)
}
if (!require("leaflet.extras")) {
  install.packages("leaflet.extras")
  library(leaflet.extras)
}
if (!require("bs4Dash")){
  install.packages("bs4Dash")
  library(bs4Dash)
}
if (!require("echarts4r")){
  install.packages("echarts4r")
  library(echarts4r)
}
if (!require("lubridate")){
  install.packages("lubridate")
  library(lubridate)
}
if (!require("rsconnect")){
  install.packages("rsconnect")
  library(rsconnect)
}
if (!require("plotly")){
  install.packages("plotly")
  library(plotly)
}
if (!require("DT")){
        install.packages("DT")
        library(DT)
}