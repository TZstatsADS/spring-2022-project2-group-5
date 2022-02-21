# Install and load related packages 
source("../lib/helpers_ui.R")
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
          title = "Statistics",
          fluidPage(
            box(
              title = "Daily reported Homeless individuals vs count of NYC residents who tested positive for SARS-CoV-2", 
              width = 12,
<<<<<<< Updated upstream
              echarts4rOutput("covid_case_count", height = 300))
            ,fluidRow(
              box(
                title = "1",
                width = 8,
                echarts4rOutput("pie_chart", height = 250))
              # ,box(
              #   title = "1",
              #   width = 6,
              #   plotlyOutput("histogram_plot", height = 250)),
              # box(
              #   title = "1",
              #   width = 6,
              #   plotlyOutput("histogram_plot", height = 250))
            )
            ,fluidRow(
              box(
                title = "1",
                width = 3,
                checkboxGroupInput("region2","select the region",
                                   choices=borough_names,
                                   selected=borough_names )
              )
              ,box(
                title = "1",
                width = 9,
                plotlyOutput("reg", height = 250))
              # ,box(
              #   title = "1",
              #   width = 6,
              #   plotlyOutput("histogram_plot", height = 250))
            )
=======
              echarts4rOutput("covid_case_count", 
                              height = 350)
              ),
            box(
              title = "Average Homlessness in NYC shelters by Type since COVID-19",
              width = 12,
              echarts4rOutput("type_histogram", height = 300)),
          ),
            fluidRow(
              box(
                title = "Proportion of homelessness by bourough",
                width = 5,
                echarts4rOutput("pie_chart", height = 340)
                ),
              box(
                title = "Homeless individuals by borough over time",
                width = 7,
                echarts4rOutput("region", height = 360)
              )
>>>>>>> Stashed changes
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

