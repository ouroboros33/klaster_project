ui <- fluidPage(

  titlePanel("Marketing customer segmentatio"), 

  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Import CSV file"),
      selectInput("method", "Method of clusterization",
                  choices = c("K-means", "DBSCAN", "hierarchical")),
      numericInput("k", "Number of clusters", value =  3, min = 2, max = 10),
      sliderInput("eps",
                  "distance threshold (eps)",
                  min = 0.1,
                  max = 5,
                  value = 0.5,
                  step = 0.1),
      actionButton("run", "Run Analysys")
    ),
    mainPanel(
      plotOutput("cluster_Plot"),
      tableOutput("summury"),
      textOutput("info")
    )
  )
)
