# Install and load related packages 
source("../lib/helpers_server.R")

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
m <-readRDS(file = "../data/data_for_statistics/m.rds")
data_borough <-readRDS(file = "../data/data_for_statistics/data_borough.rds")
data_nyc <-readRDS(file = "../data/data_for_statistics/data_nyc.rds")
most_recent_ind <-readRDS(file = "../data/data_for_statistics/most_recent_ind.rds")
borough_names <-readRDS(file = "../data/data_for_statistics/borough_names.rds")
homeless_by_type<-readRDS(file = "../data/data_for_statistics/homeless_by_type.rds")

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
    ## Statistics Tab section 1##
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
    
    ## Statistics Tab section 2##
    output$pie_chart<-renderEcharts4r({
      echarts4r::e_charts(most_recent_ind,Borough)|>
        e_pie(individuals_sum,radius=c("50%","70%"))|>
        # e_grid(top="40%")|>
        e_legend(type="plain",selector=c("all","inverse"),selectorPosition="end",orient="horizontal",top=-8)|>
        e_color(background="White")|>
        e_tooltip(trigger="item")
      
    })
    
    output$covid_case_count<-renderEcharts4r({
      echarts4r::e_charts(m, date)|>
        e_line(`Total Individuals in Shelter`,
               y_index = 0,
               smooth = FALSE,
               symbol = "none")|>
        e_line(CASE_COUNT,
               y_index=1,
               smooth = FALSE,
               symbol = "none")|>
        e_y_axis(y_index = 0,
                 #min = 42500,
                 #max = 62500,
                 name = "Number of reported individuals in shelter",
                 formatter = "{value}",
                 nameLocation = "middle",
                 nameTextStyle = list(padding = 40))|>
        e_y_axis(index = 1,
                 name = "Daily number of confirmed covid-19 patients",
                 formatter = "{value}",
                 nameLocation = "middle",
                 nameTextStyle = list(padding = 40),
                 axisLine = list(show = FALSE)) |> # here is "index"
        e_x_axis(name = "Date",
                 nameLocation = "middle",
                 nameTextStyle = list(padding = 40),
                 axisLabel = list(interval = 0),
                 axisPointer = list(
                   show = TRUE,
                   lineStyle = list(
                     color = "#cf53c2",
                     type = "dashed",
                     width = 1.5
                   )
                 )
        ) |>
        e_datazoom(type = "slider")|>
        e_tooltip(trigger = "item")|>
        e_color(background = "White") |>
        e_hide_grid_lines()
    })
    
    
    output$region<-renderEcharts4r({
      echarts4r::e_charts(data_borough%>%group_by(Borough),`Report Date`)|>
        e_line(individuals_sum,
               smooth=FALSE,
               symbol = "none")|>
        #     e_y_axis(formatter = "{value}")|>
        e_x_axis(name = "Date",
                 nameLocation = "middle",
                 nameTextStyle = list(padding = 40),
                 axisLabel = list(interval = 0),
                 axisPointer = list(
                   show = TRUE,
                   lineStyle = list(
                     color = "#cf53c2",
                     type = "dashed",
                     width = 1.5
                   )
                 )
        ) |>
        e_datazoom(type = "slider")|>
        e_tooltip(trigger = "item")|>
        e_color(background = "White") |>
        e_hide_grid_lines()
    })
    
    output$type_histogram<- renderEcharts4r({
      homeless_by_type%>%
        arrange(date)%>%
        filter(date>ymd("2020-01-01"))%>% #after the pandemic
        mutate(floor_date = floor_date(ymd(date),"6 months"))%>% #floor the date(half year)
        filter(type %in% c("Single Adult Men in Shelter",
                           "Single Adult Women in Shelter",
                           "Adult Families in Shelter",
                           "Families with Children in Shelter"))%>% #choose types
        group_by(type,floor_date)%>%
        summarise(avg=mean(number)%>%round())%>% #get the year average for each type
        ungroup()%>%
        group_by(floor_date)%>%
        echarts4r::e_chart(type,
                           timeline = T)|>
        e_bar(avg,
              realtimeSort=T,
              seriesLayoutBy="column",
              label=list(show=T,position="insideRight"))|>
        e_flip_coords()|>
        e_grid(left="22%")|>
        e_x_axis(min=0,max=14000)|>
        e_legend(show=F)|>
        e_title(left="center",top=10)|>
        e_timeline_opts(autoPlay=T,show=F)|>
        e_timeline_serie(title=list(list(text="2020 1st half",
                                         textStyle=list(fontWeight="bold",fontSize=20)),
                                    list(text="2020 2nd half"),
                                    list(text="2021 1st half"),
                                    list(text="2021 2nd half"),
                                    list(text="2022 by now")))|>
        e_tooltip(trigger = "item")|>
        e_color(background = "White")
      
      
    })
    
    ## Map Section ## 
    
    # shelters locations map
    shelterIcon <- makeIcon(
      iconUrl = "../doc/figs/house.png",
      iconWidth = 38, iconHeight = 38
    )
    output$locationMap <- renderLeaflet({
      leaflet(data=shelters_df) %>% 
        addProviderTiles(providers$CartoDB.Positron) %>%
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
    #yearx<- reactive({input$Year})
    #monthx <- reactive({input$Month})
    #datex <- input$date
    
    # Final output
    output$homelessArea <- renderLeaflet({
      
      homNewMonth <- hom %>% 
        filter(date == ceiling_date(ymd(input$date), 'month') - 1) %>% 
        arrange(BoroCD) %>%
        mutate(count = as.integer(count))
      
      #homNewMonth <- homNewMonth[order(homNewMonth$BoroCD),]
      #homNewMonth$count <- as.integer(homNewMonth$count)
      
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
        setView(lng = -74, lat = 40.71, zoom = 10) %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        addGeoJSON(geojson) %>%
        #addPolygons(popup = ~1) %>%
        addLegend(pal = pal, values = homNewMonth$count, opacity = 1.0,
                  title = "number of the homeless")      
      
    })

    #Resources Table
    benefits <- read.csv("../data/NYC_Benefits_Platform__Benefits_and_Programs_Dataset.csv", 
                         stringsAsFactors = FALSE)
    
    output$resourceTable <- renderDataTable(
      benefits %>% 
        filter(page_type == input$selectType) %>% 
        filter(program_category == input$selectCategory) %>% 
        select(program_name, population_served, brief_excerpt),
      escape = FALSE
    )
    
    # hotel map # 
    hot <- read.csv("../data/Hotels_Properties_Citywide.csv")
    Borx <- reactive({input$selecteBor})
    
    output$hotelMap <- renderLeaflet({
      
      hot = hot[hot$Borough == Borx(),]
      leaflet(data=hot) %>% 
        addProviderTiles(providers$CartoDB.Positron) %>% 
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
