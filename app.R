#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button when you open this file in RStudio. 
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)
library(lazyeval)

# Define UI for application
ui <- fluidPage(
  titlePanel("Explore SF Assessor's Office Data"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "year",
                  label = "Choose Year:", 
                  choices = c("2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016"),
                  selected = "2016"),
      
      selectInput(inputId = "color",
                  label = "Choose Color:", 
                  choices = c("Total Taxable Assessment", 
                              "Earliest Year",
                              "Aboslute Difference Previous Year",
                              "Percent Difference Previous Year"),
                  selected = "2016") 
      ),
    
    mainPanel(
      textOutput(outputId = "yearOut"),
      plotOutput(outputId ="map")
      )
    )
  )

# Define server logic required to plot map
server <- function(input, output) {
  
  # # Load the data
  # assessors_data = read_rds("./data/compressed_assessors_data_subset.rds")
  # 
  # Function for plotting the map
  
  # Set plot x and y limits and current year as reactive values
  ranges <- reactiveValues(x = NULL,
                           y = NULL)
  
  # Output the ggplot map. Code in helpers.r file
  
  currDat = reactive({
    currDat = assessors_data %>% 
      filter(`Closed Roll Year` == as.numeric(input$year))
  })
  
  output$map <- renderPlot({
    p = ggplot()+
      geom_point(data = currDat(),
                 aes(x = long,
                     y = lat,
                     color = enquo(input$color)))+
      scale_color_gradientn(trans = "log", colors = rev(rainbow(9)))#+
      #coord_map(xlim = ranges$x, ylim = ranges$y)+
      theme_classic()
    print(p)
  })
  
  output$yearOut <- renderText({
    input$year
    })
  
  # When a double-click happens, check if there's a brush on the plot.
  # If so, zoom to the brush bounds; if not, reset the zoom.
  observeEvent(input$plot_dblclick, {
    brush <- input$plot_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)

    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

