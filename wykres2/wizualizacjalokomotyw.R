
library(shiny)
library(palmerpenguins)
library(ggplot2)
library(plotly)
library(bslib)
library(dplyr)

zmienne<-c("Railcar"="carrail","Locomotive"="locomotive")
zmienna2 <- c("Electricity"="electricity","Diesel"="diesel")
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
                       multiple =T),
           selectInput('zmienna',
                       "Choose a type of vehicle:",
                       zmienne)
           
    ),
    column(6,
           selectInput('zmienna2',
                       "Choose a type of motor energy:",
                       zmienna2),
           sliderInput('rok',
                       "Choose a date range:", 
                       value=c(min(as.numeric(t5$year)),max(as.numeric(t5$year))),
                       min=min(as.numeric(t5$year)),
                       max=max(as.numeric(t5$year)),
                       step=1,
                       sep = ""))
    
  ),
  fluidRow(
    column(12,
           plotlyOutput("barPlot")
    ),
    
  ),
  
  
)


server <- function(input, output) {
  
  output$table <- renderTable({
    
  })
  
  
  output$barPlot <- renderPlotly({
    plot_ly(
      t5%>%filter(t5$TIME %in% input$kraj,
                  t5$year>=input$rok[1],
                  t5$year<=input$rok[2])%>% 
        select(TIME,year,n = paste(input$zmienna2,input$zmienna, sep ="_")), 
      x= ~year,
      y= ~n,
      color = ~TIME,
      type = "bar") %>%
      layout(title='Number of machines based on its type and energy',
             xaxis = list(title = 'Year'),
             yaxis = list(title = 'Number of machines'))
    
  })
  
  
}


shinyApp(ui = ui, server = server)

