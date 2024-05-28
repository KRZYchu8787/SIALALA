library(shiny)
library(dplyr)
library(leaflet)

secs_to_hours <- function(secs) {
  hours = secs %/% 3600
  mins = (secs - hours * 3600) %/% 60
  hours = ifelse(nchar(as.character(hours)) < 2, paste0("0", as.character(hours)),
                 as.character(hours))
  mins = ifelse(nchar(as.character(mins)) < 2, paste0("0", as.character(mins)),
                as.character(mins))
  paste(hours, mins, sep = ":")
}

stops <- read.delim("pkpic/stops.txt", sep = ",")

ui <- fluidPage(

    titlePanel("Railways in Poland"),
    
    fluidRow(
      column(6, 
             textOutput("text1"),
             selectInput("station",
                         "Choose the starting station:",
                         unique(stops$stop_name)),
             selectInput("statistics",
                         "Choose preferred statistics:",
                         c("Minimal time" = "min_time", 
                           "Average time" = "mean_time"))
             ),
      column(6, 
             textOutput("text2"),
             selectInput("station1",
                         "Choose the starting station:",
                         unique(stops$stop_name)),
             uiOutput("station2")
             )
    ),
    
    fluidRow(
      column(6, 
             leafletOutput("map1")
      ),
      column(6, 
             leafletOutput("map2")
      )
    )

)


server <- function(input, output) {
    
    output$text1 <- renderText({"How long does a train journey take?"})
    
    output$text2 <- renderText({"What is the fastest route from station A to 
      station B?"})
    
    output$map1 <- renderLeaflet({
      file <- paste0("data/", gsub(" ", "_", input$station))
      req_station <- readRDS(file)
      
      req_station <- req_station %>% 
        group_by(stop_name) %>% 
        mutate(min_time = min(min_time), mean_time = mean(mean_time))
        
      statistics <- as.vector(t(req_station[, input$statistics]))
     
      pal <- colorNumeric(
        palette = c("darkgreen", "yellow", "red"),
        domain = statistics)
    
      leaflet(req_station) %>% 
        addTiles() %>% 
        addCircleMarkers(radius = 5, opacity = 1, fillOpacity = 1, 
                         lng = ~stop_lon, lat = ~stop_lat, 
                         color = ~pal(statistics), 
                         popup = paste0("Station: ", req_station$stop_name,
                                        "<br>Time: ", 
                                        secs_to_hours(statistics)))
      
    }) %>% bindCache(input$station, input$statistics)
    
    output$station2 <- renderUI({
      file <- paste0("data/", gsub(" ", "_", input$station1))
      req_station <- readRDS(file)
      
      selectInput("station2", "Choose the destination:", 
                  unique(req_station$stop_name))  
    })
    
    output$map2 <- renderLeaflet({
      file <- paste0("data/", gsub(" ", "_", input$station1))
      req_station <- readRDS(file)
      
      trips <- req_station %>% 
        filter(stop_name %in% input$station2) %>% 
        filter(min_time == suppressWarnings(min(min_time)))
      
      trip_names <- trips$trip_short_name
      col <- palette.colors(palette = "Set2")[1:length(trip_names)]
      length(trip_names) <- length(col)
      
      pal <- data.frame(trip = trip_names, col = col)
      
      map <- leaflet(req_station) 
      
      for (trip in trips$trip_short_name) {
        trip_time <- req_station %>% 
          filter(trip_short_name == trip & stop_name %in% input$station2) %>% 
          pull(min_time)
        
        route <- req_station %>% 
          filter(trip_short_name == trip & min_time <= trip_time) %>% 
          arrange(min_time)
        
        map <- map %>% 
          addTiles() %>% 
          addCircleMarkers(data = route, radius = 5, opacity = 1, fillOpacity = 1, 
                           lng = ~stop_lon, lat = ~stop_lat, 
                           color = pal[pal$trip == trip, "col"], 
                           popup = paste0("Station: ", route$stop_name,
                                          "<br>Time: ",
                                          secs_to_hours(route$min_time))) %>% 
          addPolylines(data = route, opacity = 1, lng = ~stop_lon, lat = ~stop_lat, 
                       color = pal[pal$trip == trip, "col"])
      }
      
      map
      
    }) %>% bindCache(input$station1, input$station2)
}


shinyApp(ui = ui, server = server)
