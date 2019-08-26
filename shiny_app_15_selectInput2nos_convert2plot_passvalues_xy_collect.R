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
              
              selectInput(inputId = "x",label = "X-Axis",
                          choices = varlist, 
                          selected = "lifeExp")
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

    gapminder %>%  
    ggplot (aes_string(x = input$x, y = input$y))+
      geom_point()
      
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

