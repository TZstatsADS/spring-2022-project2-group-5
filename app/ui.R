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
            title = tags$b("Information"),
            maximizable = TRUE,
            elevation = 3,
            collapsible = FALSE
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
          title = "Affected Areas",
          fluidRow(
            # box for homeless area
            box(title = "Select month",
                width = 3,
                dateInput("date", 
                        "Month and Year", 
                        #min = 2020, 
                        #max = 2021, 
                        #value = 2021,
                        #step = 1
                        )
              ),
            box(title = "Number of Homeless",
                width = 9,
                leafletOutput("homelessArea")
            )
          )
        )
        ,
        tabPanel(
          title = "Resources",
          fluidRow(
            box(
              title = "Filters",
              width = 3,
              selectInput("selecteBor", 
                          "Select Borough", 
                          choices = c("Bronx" = "BRONX", 
                                      "Queens" = "QUEENS", 
                                      "Manhattan" = "MANHATTAN", 
                                      "Brooklyn" = "BROOKLYN", 
                                      "Staten Island" = "STATEN IS"), 
                          selected = "Queens"
              ),
              selectInput("selectPrice",
                          "Price",
                          choices = c("option 1",
                                      "option 2")),
              selectInput("selectCategory",
                          "Category",
                          choices = c("option 1",
                                      "otpion 2"))
            ),
            box(title = "Shelters",
                leafletOutput("locationMap", height = 350),
                width = 9),
            box(title = "Hotels",
                width = 12,
                leafletOutput("hotelMap", height = 350))
          )
        )
        
      )
    )
  )
}

