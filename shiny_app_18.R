library(shiny)
library(ggplot2)
library(gapminder)
library(DT)
library(dplyr)

varlist <- names(gapminder)

# Define UI for application that draws a histogram
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
              
              # Set alpha level
              sliderInput(inputId = "alpha", 
                          label = "Alpha:", 
                          min = 0, max = 1, 
                          value = 0.5, step = 1)
              
              
                    ),
   
   mainPanel (
            plotOutput("plot")
            )
      )
   )

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  #Create the table
  output$plot <- renderPlot({

  p <-gapminder %>%  
      ggplot (aes_string(x = input$x, y = input$y, color = input$z))+
      geom_point(alpha = input$alpha)
      
  if (input$logy) {
    p <- p + scale_y_log10()
  }
  
  p
  
  
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

