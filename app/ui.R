# Install and load related packages 
source("www/helpers_ui.R")
borough_names <-readRDS(file = "www/data_for_statistics/borough_names.rds")
benefits <- read.csv("www/NYC_Benefits_Platform__Benefits_and_Programs_Dataset.csv", 
                     stringsAsFactors = FALSE)

# Define UI for application
ui <- function(){
        bs4DashPage(
                title = "NYC Homelessness Dashboard",
                header = bs4DashNavbar(
                        title = htmlOutput("icu"),
                        titleWidth = 30,
                        fixed = TRUE
                ),
                sidebar = bs4DashSidebar(disable = TRUE),
                body = bs4DashBody(
                        # autoWaiter(),
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
                            font-size: 30px;
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
	                          line-height: 36px;
	                          font-weight: bold;
	                          font-family: 'Josefin Sans', sans-serif;
            }")),
                                                               p(id = "body",
                                                                 "At the beginning of 2020, the spread of Covid-19 has an effect to the world as well as New York City.",
                                                                 "In this app we tend to focus on the effect of homelessness in NY during pandenmic.",
                                                                 "We want to discover what is the potential influence of virus to homeless people and provide some suggestions
               on how to help these people.",
                                                                 "The main content of this app is:"),
                                                               tags$style(HTML("#body{
                            margin: 1em 0 0.5em 0;
	                          color: #343434;
	                          font-size: 15px;
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
	                          font-size: 15px;
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
                                                        )# end of column
                                                ) # end of fluid row
                                        ),
                                        box(
                                                width = 12,
                                                title = tags$b("Covid-19 Situation"),
                                                maximizable = TRUE,
                                                elevation = 3,
                                                collapsible = FALSE,
                                                fluidRow(
                                                        column(10,
                                                               tags$div(img(src = "covid.gif", width = 1200, height = 300), style="text-align: center;")
                                                        ) # end of column
                                                ) # end of fluid row
                                        )# end of box
                                ), # end of title page
                                tabPanel(
                                        title = "Statistics",
                                        fluidPage(
                                                box(
                                                        title = "Daily reported Homeless individuals vs count of NYC residents who tested positive for SARS-CoV-2", 
                                                        width = 12,
                                                        echarts4rOutput("covid_case_count", height = 300))
                                                ,box(
                                                        title = "Average Homlessness in NYC shelters by Type since COVID-19",
                                                        width = 12,
                                                        echarts4rOutput("type_histogram", height = 300))
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
                                        )
                                ),
                                tabPanel(
                                        title = "Affected Areas",
                                        fluidRow(
                                                # box for homeless area
                                                box(title = "Select date between March 2020 - Dec 2021",
                                                    width = 3,
                                                    dateInput("date", 
                                                              "Select date:",
                                                              max = "2021-12-31",
                                                              min = "2020-03-01",
                                                              value = "2021-12-31"
                                                    )
                                                ),
                                                box(
                                                        title = "Number of Homeless",
                                                        width = 9,
                                                        leafletOutput("homelessArea",
                                                                      height = 600)
                                                )
                                        )
                                ),
                                tabPanel(
                                        title = "Resources",
                                        fluidRow(
                                                box(
                                                        title = "Shelters in NYC",
                                                        leafletOutput("locationMap", height = 350),
                                                        width = 12),
                                                box(
                                                        title = "Select the options below to find resources in NYC",
                                                        width = 12,
                                                        selectInput("selectType",
                                                                    "Type",
                                                                    choices = unique(benefits$page_type),
                                                                    selected = "Benefit"
                                                        ),
                                                        selectInput("selectCategory",
                                                                    "Category",
                                                                    choices = unique(benefits$program_category),
                                                                    selected = "Food"
                                                        )),
                                                box(
                                                        width = 12,
                                                        title = "Resources",
                                                        collapsible = TRUE,
                                                        dataTableOutput("resourceTable")
                                                ),
                                                box(
                                                        width = 12,
                                                        title = "How to apply",
                                                        collapsible = FALSE,
                                                        dataTableOutput("apply")
                                                ),
                                                box(
                                                        title = "Filters",
                                                        selectInput("selecteBor", 
                                                                    "Select Borough", 
                                                                    choices = c("Bronx" = "BRONX", 
                                                                                "Queens" = "QUEENS", 
                                                                                "Manhattan" = "MANHATTAN", 
                                                                                "Brooklyn" = "BROOKLYN", 
                                                                                "Staten Island" = "STATEN IS"), 
                                                                    selected = "Queens"
                                                        )
                                                ),
                                                
                                                box(
                                                        title = "Hotels",
                                                        width = 6,
                                                        leafletOutput("hotelMap", height = 350))
                                        )
                                ),
                                tabPanel(
                                        title = "About",
                                        mainPanel(width=12, h1(strong("ABOUT"), align="center")),     
                                        mainPanel(width=12, h2(strong("Contributors"), align="center")),
                                        h4("Haozhong Zheng, hz2694@columbia.edu", align="center"),
                                        h4("Huiying Wang, hw2816@columbia.edu", align = "center"),
                                        h4("Jiahao Shao, js5954@columbia.edu", align = "center"),
                                        h4("Sarah Quinn Kurihara, sqk2003@columbia.edu", align = "center"),
                                        br(),
                                        mainPanel(width = 12, h2(strong("Data Resrouce"), align = "center")),
                                        h4(a("Associated Address by Borough and Community District", href =
                                                     "https://data.cityofnewyork.us/Social-Services/Associated-Address-by-Borough-and-Community-Distri/ur7y-ziyb"),
                                           align = "center"),
                                        h4(a("COVID-19 Daily Counts of Cases, Hospitalizations, and Deaths",
                                             href = "https://data.cityofnewyork.us/Health/COVID-19-Daily-Counts-of-Cases-Hospitalizations-an/rc75-m7u3"),
                                           align = "center"),
                                        h4(a("Directory Of Homeless Drop- In Centers", href = 
                                                     "https://data.cityofnewyork.us/Social-Services/Directory-Of-Homeless-Drop-In-Centers/bmxf-3rd4"),
                                           align = "center"),
                                        h4(a("DHS Daily Report", href = "https://data.cityofnewyork.us/Social-Services/DHS-Daily-Report/k46n-sa2m"),
                                           align = "center"),
                                        br(),
                                        mainPanel(width = 12, h2(strong("Github"), align = "center")),
                                        h4("The project for this app is on ", a("Github",
                                                                                href = "https://github.com/TZstatsADS/spring-2022-project2-group-5"), ".", 
                                           img(src = "github.png", width = 50, height = 50),
                                           align = "center")
                                )
                                
                        )

                )
        )
}


