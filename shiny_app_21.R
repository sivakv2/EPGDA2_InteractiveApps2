library(shiny)
library(ggplot2)
library(gapminder)
library(DT)
library(dplyr)

varlist <- names(gapminder)

# Define UI for application that draws a plot
ui <- fluidPage(
   
   # Application title
   titlePanel("Gapminder Data"),
   
   sidebarLayout(
     sidebarPanel(
              selectInput(inputId = "y",label = "Y-Axis",
                          choices = varlist,
                          selected = "gdpPercap"),
              
              checkboxInput("logy","Add y log values", value = FALSE),
              
                            selectInput(inputId = "x",label = "X-Axis",
                          choices = varlist, 
                          selected = "lifeExp"),
              
              selectInput(inputId = "z",label = "Color",
                          choices = varlist, 
                          selected = "continent"),
              
              sliderInput(inputId = "year", 
                          label = "Year", 
                          min = 1957, max = 2007, 
                          value = c(1957,2007), step = 5)
              
                    ),
   
   mainPanel (
            plotOutput(outputId = "plot", brush = "plot_brush"),
            dataTableOutput("table")
            )
      )
   )

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  #Create the table
  output$plot <- renderPlot({

    gp_ds <- gapminder %>%
      filter(year >= input$year[1] & year <= input$year[2])
    
  p <-gp_ds %>%  
      ggplot (aes_string(x = input$x, y = input$y, color = input$z))+
      geom_point()+
      facet_grid(~continent)
      
  if (input$logy) {
    p <- p + scale_y_log10()
  }
  
  p
  
  
    })
  
  #Create the table
  output$table <- renderDataTable({
    gp_ds <- gapminder %>%
      filter(year >= input$year[1] & year <= input$year[2])
    
    brushedPoints(gp_ds, brush = input$plot_brush)
    
    })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

