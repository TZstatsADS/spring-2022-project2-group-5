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

## Add dependencies
use_deps <- function(){
    tagList(
        shinyjs::useShinyjs(),
        waiter::use_waiter(),
        waiter::use_hostess()
    )
}

#Data Processing
covid_df <- read.csv('../data/covid_tidy.csv')
homeless_df <- read.csv('../data/homeless_tidy.csv')

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
    set.seed(122)
    histdata <- rnorm(500)
    output$plot1 <- renderPlot({
        data <- histdata[seq_len(input$slider)]
        hist(data)
    })
    
    ## Map Section ## 
    mapdata <- homeless_df
    
    output$plot2 <- renderPlot({
        data <- mapdata[]
    })
    
    
}