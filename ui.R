library(shiny)
library(shinythemes)
thematic_shiny()

ui <- fluidPage(

  theme = custom_theme,
  
 titlePanel("Marketing Customer Segmentation"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Import CSV file", accept = ".csv"),
      
      # Add data summary
      verbatimTextOutput("dataSummary"),
      
      selectInput("method", "Method of Clusterization",
                  choices = c("K-means", "DBSCAN", "hierarchical")),
      
      conditionalPanel(
        condition = "input.method == 'K-means'",
        numericInput("k", "Number of clusters", value = 3, min = 2, max = 10)
      ),
      conditionalPanel(
        condition = "input.method == 'DBSCAN'",
        sliderInput("eps", "Distance threshold (eps)",
                    min = 0.1, max = 5, value = 0.5, step = 0.1),
        numericInput("minpts", "MinPts:", value = 5, min = 1, max = 50)
      ),
      conditionalPanel(
        condition = "input.method == 'hierarchical'",
        selectInput("linkage", "Link method:",
                    choices = c("complete", "single", "average", "ward.D2")),
        numericInput("k", "Number of clusters", value = 3, min = 2, max = 10)
      ),
      actionButton("run", "Run Analysis"),
      actionButton("exit", "Exit")
    ),
    
    mainPanel(
      plotOutput("cluster_Plot"),
      tableOutput("summary"),
      verbatimTextOutput("info")
    )
  )
)
