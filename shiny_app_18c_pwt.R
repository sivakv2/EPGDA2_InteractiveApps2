library(shiny)
library(ggplot2)
library(gapminder)
library(DT)
library(dplyr)
library(readxl)


pwt91 <- read_excel("~/Downloads/pwt91-2.xlsx", 
                      sheet = "Data")
varlist <- names(pwt91)

# Define UI for application that draws a plot
ui <- fluidPage(
   
   # Application title
   titlePanel("PWT Data"),
   
   sidebarLayout(
     sidebarPanel(
              selectInput(inputId = "y",label = "Y-Axis",
                          choices = varlist,
                          selected = "rgdpe"),
              
              checkboxInput("logy","Add y log values", value = FALSE),
              
                            selectInput(inputId = "x",label = "X-Axis",
                          choices = varlist, 
                          selected = "avh"),
              
              selectInput(inputId = "z",label = "Color",
                          choices = varlist, 
                          selected = "hc"),
              
              # Set Year
              sliderInput(inputId = "year", 
                          label = "Year", 
                          min = 1950, max = 2017, 
                          value = c(1950,2017), step = 1)
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

    gp_ds <- pwt91 %>%
      filter(year >= input$year[1] & year <= input$year[2])
    
  p <-gp_ds %>%  
      ggplot (aes_string(x = input$x, y = input$y, color = input$z))+
      geom_point()
      
  if (input$logy) {
    p <- p + scale_y_log10()
  }
  
  p
  
  
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

