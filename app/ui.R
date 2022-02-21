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
            title = tags$b("Introduction"),
            maximizable = TRUE,
            elevation = 3,
            collapsible = FALSE,
            fluidRow(
            column(6,
                   img(src = "homeless.gif", width = '100%')),
            column(6,
            h1(id = "title","Where you can help during COVID-19", align = "center"),
            tags$style(HTML("#title{margin: 1em 0 0.5em 0;
                            font-size: 36px;
                            line-height: 36px;
                            font-style: bold; 
                            font-family: 'Ultra', sans-serif;
                            color: #148773;
                            font-weight: normal;
                            text-transform: uppercase;
                            text-shadow: 0 2px white, 0 3px #777;
                            }")),
            h2(id ="subtitle", "Homelessness during pandenmic", align = "center"),
            tags$style(HTML("#subtitle{
                            margin: 1em 0 0.5em 0;
	                          color: #00caa6;
	                          font-size: 26px;
	                          line-height: 40px;
	                          font-weight: bold;
	                          font-family: 'Josefin Sans', sans-serif;
            }")),
            br(),
            p(id = "body",
               "At the beginning of 2020, the spread of Covid-19 has an effect to the world as well as New York City.",
               "In this app we tend to focus on the effect of homelessness in NY during pandenmic.",
               "We want to discover what is the potential influence of virus to homeless people and provide some suggestions
               on how to help these people.",
              "The main content of this app is:"),
            tags$style(HTML("#body{
                            margin: 1em 0 0.5em 0;
	                          color: #343434;
	                          font-size: 18px;
	                          line-height: 20px;
	                          font-family: 'Josefin Sans', sans-serif;
            }")),
            h4(id = "bullet",
                tags$li("Statistics about Covid-19 in New York"),
                tags$li("Statistics about Homelessness in New York"),
                tags$li("Map of Homelessness"),
                tags$li("Where you can help? -- Our Suggestion"),
                tags$li("Summary")),
            tags$style(HTML("#bullet{
                            margin: 1em 0 0.5em 0;
	                          color: #343434;
	                          font-size: 18px;
	                          line-height: 20px;
	                          font-weight: bold;
	                          font-family: 'Josefin Sans', sans-serif;
	                          text-align: left;
            }")),
            p(id = "body",
              "The district on our map is called ",
              tags$a(href = "https://communityprofiles.planning.nyc.gov/", "community district"),
              "defined by NYC Department of City Planning.",
              "The majority of homeless people are in ",
              a(href = "https://communityprofiles.planning.nyc.gov/bronx/1", "Bronx 1"),
              " ,",
              a(href = "https://communityprofiles.planning.nyc.gov/bronx/3", "Bronx 3"),
              " ,",
              a(href = "https://communityprofiles.planning.nyc.gov/bronx/4", "Bronx 4"),
              " ,",
              a(href = "https://communityprofiles.planning.nyc.gov/bronx/5", "Bronx 5"),
              " ,",
              a(href = "https://communityprofiles.planning.nyc.gov/bronx/9", "Bronx 9"),
              " ,",
              a(href = "https://communityprofiles.planning.nyc.gov/bronx/12", "Bronx 12"),
              " ,",
              a(href = "https://communityprofiles.planning.nyc.gov/brooklyn/4", "Brooklyn 4"),
              " ,",
              a(href = "https://communityprofiles.planning.nyc.gov/brooklyn/5", "Brooklyn 5"),
              " ,",
              a(href = "https://communityprofiles.planning.nyc.gov/brooklyn/16", "Brooklyn 16"),
              " , and ",
              a(href = "https://communityprofiles.planning.nyc.gov/queens/12", "Queens 12"),
              ".")
           )# end of box
          ) # end of column
        ) # end of fluid row
      ), # end of title page
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

