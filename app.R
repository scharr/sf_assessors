#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
source("helpers.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Brush and double-click to zoom")
      ),
    
    mainPanel(
      mainPanel(plotOutput("map",
                           dblclick = "plot1_dblclick",
                           brush = brushOpts(
                             id = "plot1_brush",
                             resetOnNew = TRUE)
                           )
                )
      )
    )
  )

# Define server logic required to plot map
server <- function(input, output) {
  dat_loaded = read_rds("./data/dat_sub.rds")
  ranges <- reactiveValues(x = NULL, y = NULL)
  
  # Output the ggplot map. Code in helpers.r file
  output$map <- renderPlot({
    properties_map(ranges)
  })
  
  # When a double-click happens, check if there's a brush on the plot.
  # If so, zoom to the brush bounds; if not, reset the zoom.
  observeEvent(input$plot1_dblclick, {
    brush <- input$plot1_brush
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

