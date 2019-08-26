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
              
              selectInput(inputId = "x",label = "X-Axis",
                          choices = varlist, 
                          selected = "lifeExp"),
              
              checkboxInput("logy","Add y log values", value = FALSE)
              
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
      ggplot (aes_string(x = input$x, y = input$y))+
      geom_point()
      
  if (input$logy) {
    p <- p + scale_y_log10()
  }
  
  p
  
  
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

