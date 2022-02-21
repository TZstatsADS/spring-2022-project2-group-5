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
if (!require("geojsonio")){
  install.packages("geojsonio")
  library(geojsonio)
}
if (!require("RColorBrewer")){
  install.packages("RColorBrewer")
  library(RColorBrewer)
}
if (!require("rgdal")){
  install.packages("rgdal")
  library(rgdal)
}
if (!require("jsonlite")){
  install.packages("jsonlite")
  library(jsonlite)
}
if (!require("rsconnect")){
  install.packages("rsconnect")
  library(rsconnect)
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
    
    
    # area map #
    # set up map
    geojson <- readLines("../doc/nyccomadd.json", warn = FALSE) %>%
      paste(collapse = "\n") %>%
      fromJSON(simplifyVector = FALSE)
    
    # Default styles for all features
    geojson$style = list(
      weight = 1,
      color = "red",
      opacity = 1,
      fillOpacity = 0.8
    )
    
    #set up dataset
    hom <- homeless_df
    hom$Month <- month(ymd(hom$date))
    hom$Year <- year(ymd(hom$date))
    
    #Reactive
    yearx<- reactive({input$Year})
    monthx <- reactive({input$Month})

    
    # Final output
    output$homelessArea <- renderLeaflet({
      
      homNewMonth<-hom[hom$Year == yearx() & hom$Month == monthx(), ]
      homNewMonth <- homNewMonth[order(homNewMonth$BoroCD),]
      homNewMonth$count <- as.integer(homNewMonth$count)
      
      # Color by per-capita GDP using quantiles
      pal=colorNumeric("YlOrRd", homNewMonth$count)
      # Add a properties$style list to each feature
      geojson$features <- lapply(geojson$features, function(feat) {
        feat$properties$style <- list(
          fillColor = pal(
            # data$count with this CD
            homNewMonth[homNewMonth$BoroCD == feat$properties$BoroCD,]$count
            #feat$properties$gdp_md_est / max(1, feat$properties$pop_est)
          )
        )
        feat
      })
      
      leaflet() %>% 
        setView(lng = -74, lat = 40.71, zoom = 11) %>%
        addTiles() %>%
        addGeoJSON(geojson) %>%
        #addPolygons(popup = ~1) %>%
        addLegend(pal = pal, values = homNewMonth$count, opacity = 1.0,
                  title = "number of the homeless")      
      
    })

    
    # hotel map #
    hot <- read.csv("../data/Hotels_Properties_Citywide.csv")
    Borx <- reactive({input$selecteBor})
    
    output$hotelMap <- renderLeaflet({
      
      hot = hot[hot$Borough == Borx(),]
      leaflet(data=hot) %>% addTiles() %>%
        addMarkers(~Longitude, ~Latitude, popup = ~as.character(OWNER_NAME))
      
    })
    
    
    
    #output$plot2 <- renderLeaflet({
    #    leaflet() %>% 
    #        #change map look: http://leaflet-extras.github.io/leaflet-providers/preview/index.html
    #        addProviderTiles(providers$CartoDB.Positron) %>% 
    #        addMarkers(data = shelters_df)
    #})
}

#setwd("D:/OneDrive/Documents/5243/spring-2022-project2-group-5/app")
#getwd()
