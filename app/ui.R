# Install and load related packages 
source("../doc/helpers_ui.R")
borough_names <-readRDS(file = "../data/data_for_statistics/borough_names.rds")

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
            title = tags$b("Introduction"),
            maximizable = TRUE,
            elevation = 3,
            collapsible = FALSE,
            h1(id = "title","Where you can help during COVID-19", align = "center"),
            tags$style(HTML("#title{margin: 1em 0 0.5em 0;
                            font-size: 36px;
                            line-height: 36px;
                            font-style: bold; 
                            font-family: 'Ultra', sans-serif;
                            color: #343434;
                            font-weight: normal;
                            text-transform: uppercase;
                            text-shadow: 0 2px white, 0 3px #777;
                            }")),
            h2(id ="subtitle", "Homelessness during pandenmic", align = "center"),
            div(img(src = "homeless.gif", width = '50%'))
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
          title = "Statistics",
          fluidPage(
            box(
              title = "Number of homeless individuals and confirmed COVID-19 cases", 
              width = 12,
              echarts4rOutput("covid_case_count", 
                              height = 350)
              ),
            fluidRow(
              box(
                title = "Borough",
                width = 2,
                checkboxGroupInput("region2",
                                   "Select borough",
                                   choices = borough_names,
                                   selected = borough_names)
                                   #height = 350)
              ),
              box(
                title = "Proportion of homelessness by bourough",
                width = 5,
                echarts4rOutput("pie_chart", height = 350)
                ),
              box(
                title = "Homeless rates over time",
                width = 5,
                plotlyOutput("reg", height = 350)
              )
              
              # ,box(
              #   title = "1",
              #   width = 6,
              #   plotlyOutput("histogram_plot", height = 250)),
              # box(
              #   title = "1",
              #   width = 6,
              #   plotlyOutput("histogram_plot", height = 250))
              # box(
              #   title = "1",
              #   width = 6,
              #   plotlyOutput("histogram_plot", height = 250))
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
        ),
        tabPanel(
          title = "The Homeless Map",
          fluidRow(
            # box for shelters locations
            box(title = "shelter for the homeless"),
            box(leafletOutput("locationMap")), 
            
            # box for homeless area
            box("select a time", 
              sliderInput(
                "Year", "year", min = 2020, max = 2021, value = 2021,
                step = 1
              ),
              sliderInput(
                "Month", "month", min = 1, max = 12, value = 3,
                step = 1
              )
            ),
            box(
              leafletOutput("homelessArea")
            )
          )
        )
        ,
        tabPanel(
          title = "Hotel map",
          fluidRow(
            box(
             title = "Borough",
              selectInput("selecteBor", "Select Borough", choices = c("Bronx" = "BRONX", 
                  "Queens" = "QUEENS", "Manhattan" = "MANHATTAN", "Brooklyn" = "BROOKLYN", 
                  "Staten Island" = "STATEN IS"), selected = "Queens"
              )
            ),
            box(leafletOutput("hotelMap"))
          )
        )
        
      )
    )
  )
}

