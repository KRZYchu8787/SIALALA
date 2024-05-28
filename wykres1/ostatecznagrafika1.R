
library(shiny)
library(palmerpenguins)
library(ggplot2)
library(plotly)
library(bslib)
library(dplyr)


zmienne<-c("Total" = "total","Passenger" = "passengers",
           "Employee"="employee","Level crossing user" = "lvlcrossingusers",
           "Unauthorised"="unauthorised","Unknown"="unknown")
ui <- fluidPage(
  HTML('<style>
       .checkbox-inline {
         margin-left: 10px;
       }
       </style
       '),
  
  titlePanel(""),
  textOutput('text'),
  
  fluidRow(
    column(6, 
           selectInput('kraj',
                              "Choose a country:",
                              choices = unique(t5$TIME), 
                              selected = "Poland",
                               multiple =T) ,
           sliderInput('rok',
                       "Choose a date range:", 
                       value=c(min(as.numeric(t5$year)),max(as.numeric(t5$year))),
                       min=min(as.numeric(t5$year)),
                       max=max(as.numeric(t5$year)),
                       step=1,
                       sep = "")
           
    ),
    column(6,
           selectInput('zmienna',
                       "Choose a category of a person:",
                       zmienne))
    
  ),
  fluidRow(
    column(12,
           plotlyOutput("pointPlot")
    ),
    
  ),
  
  
)


server <- function(input, output) {
  
  output$table <- renderTable({
    
  })
  
  
  output$pointPlot <- renderPlotly({
    plot_ly(
      t5%>%filter(t5$TIME %in% input$kraj,
                  t5$year>=input$rok[1],
                  t5$year<=input$rok[2])%>% select(TIME,year,n = input$zmienna), 
      x= ~year,
      y= ~n,
      color=~TIME,
      colors='Set1',
      type = "scatter",
      mode = 'lines+markers',
      line = list(width = 1))%>%
      layout(title='Number of people killed in railway accidents',
             xaxis = list(title = 'Year'),
             yaxis = list(title = 'Number of people killed')) 
    
  })

  
}


shinyApp(ui = ui, server = server)


