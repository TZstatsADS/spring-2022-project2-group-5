# Install related packages 

if (!require("shiny")) {
    install.packages("shiny")
    library(shiny)
}
if (!require("leaflet")) {
    install.packages("leaflet")
    library(leaflet)
}
if (!require("leaflet.extras")) {
    install.packages("leaflet.extras")
    library(leaflet.extras)
}
if (!require("dplyr")) {
    install.packages("dplyr")
    library(dplyr)
}
if (!require("magrittr")) {
    install.packages("magrittr")
    library(magrittr)
}
if (!require("mapview")) {
    install.packages("mapview")
    library(mapview)
}
if (!require("leafsync")) {
    install.packages("leafsync")
    library(leafsync)
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

## Add dependencies
use_deps <- function(){
    tagList(
        shinyjs::useShinyjs(),
        waiter::use_waiter(),
        waiter::use_hostess()
    )
}

#Data Processing
print(getwd())
covid_df <- read.csv('../data/covid_tidy.csv') 
homeless_df <- read.csv('../data/homeless_tidy.csv')
shelters_df <- read.csv('../data/shelters_tidy.csv')

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    ##Loading Pages
    # loadme <- hostess_loader(
    #     preset = "circle",
    #     text_color = "black",
    #     class = "label-center",
    #     center_page = TRUE,
    #     progress_type = "fill",
    #     fill_color = hostess_gradient(angle = 90,
    #                                   colors = c("#FFE469"))
    # )
    # hostess <- Hostess$new(infinite =TRUE)$set_loader(loadme)
    # w <- waiter::Waiter$new(
    #     fadeout = TRUE,
    #     html = span(
    #         tags$html(
    #             tags$body(
    #                 tags$section(
    #                     tags$div(id = "host_init_title", tags$b("Hello!")),
    #                     hostess$get_loader(),
    #                     tags$div(id = "host_init_subtitle", tags$b("Starting..."))
    #                 )
    #             )
    #         )
    #     )
    # )
    # w$show()
    # hostess$start()

    ## Homepage section ##
    
    
    

    ## Statistics Tab section ##
    #covid_df <- covid_df %>% 
        #mutate(date = ymd(covid_df$date)) %>% 
        #mutate(date)
    output$plot1 <- renderEcharts4r({
        #data <- histdata[seq_len(input$slider)]
        covid_df %>% 
        e_charts(date) %>% 
        e_line(case_count) %>% 
        e_area(death_count) %>% 
        e_hide_grid_lines() 
    })
    
    output$plot3 <- renderEcharts4r({
        homeless_df %>% 
            filter(borough == input$neighborhood_select) %>% 
            group_by(borough) %>% 
            e_charts(date) %>% 
            e_bar(count, stack = "borough") %>% 
            e_hide_grid_lines()
    })
    
    ## Map Section ## 
    
    # shelters locations map
    shelterIcon <- makeIcon(
      iconUrl = "../doc/figs/house.png",
      iconWidth = 38, iconHeight = 38
    )
    output$locationMap <- renderLeaflet({
      leaflet(data=shelters_df) %>% addTiles() %>%
        addMarkers(~longitude, ~latitude, popup = ~as.character(Comments),
                   label = ~as.character(name), icon = shelterIcon)
      
    })
    
    
    
    #output$plot2 <- renderLeaflet({
    #    leaflet() %>% 
    #        #change map look: http://leaflet-extras.github.io/leaflet-providers/preview/index.html
    #        addProviderTiles(providers$CartoDB.Positron) %>% 
    #        addMarkers(data = shelters_df)
    #})
}


