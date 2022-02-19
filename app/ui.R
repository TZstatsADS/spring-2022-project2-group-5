
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

# Define UI for application
ui <- function(){
  bs4DashPage(
    title = "NYC Homelessness Dashboard",
    # preloader = list(
    #   html = span(hostess$get_loader()),
    # ),
    header = bs4DashNavbar(
      fixed = TRUE
    ),
    sidebar = bs4DashSidebar(disable = TRUE),
    body = bs4DashBody(
      tabsetPanel(
        id = "main_tabs",
        tabPanel(
          title = "Home",
          box(
            width = 12,
            title = tags$b("Information"),
            maximizable = TRUE,
            elevation = 3,
            collapsible = FALSE
          )
        ),
        tabPanel(
          title = "Statistics",
          fluidPage(
            fluidRow(
              box(
                title = "Date Range",
                width = 6,
                dateRangeInput("dates", "Date range"),
                selectInput(inputId = "neighborhood_select", 
                            label = "Select neighborhoods", 
                            choices = list("Bronx",
                                           "Brooklyn",
                                           "Manhattan",
                                           "Queens",
                                           "Staten Island"),
                            multiple = TRUE,
                            selected = list("Bronx",
                                       "Brooklyn",
                                       "Manhattan",
                                       "Queens",
                                       "Staten Island")
                            )
              ),
              box(
                title = "Controls",
                width = 6,
                sliderInput("slider", "Number of observations", 1, 100, 50)
              )),
            box(
              title = "COVID Rates",
              width = 12,
              echarts4rOutput("plot1", height = 250)
            ),
            box(
              title = "Homelessness Rates",
              width = 12,
              echarts4rOutput("plot3", height = 250)
            )
          )
        ),
        tabPanel(
          title = "Map",
          fluidRow(
            box(
              title = "Neighborhoods",
              selectInput("selecter", "Select neighborhoods", choices = list("Bronx" = 1, 
                                                                             "Manhattan" = 2))
            ),
            box(leafletOutput("plot2", height = 250))
            
          )
        )
      )
    )
  )
}
