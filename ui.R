ui <- fluidPage(

  titlePanel("Marketing customer segmentatio"), 

  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Import CSV file"),
      # панелька выбора метода
      selectInput("method", "Method of clusterization",
                  choices = c("K-means", "DBSCAN", "hierarchical")),
      conditionalPanel(
        condition = "input.method == 'K-means'",
        numericInput("k", "Number of clusters", value = 3, min = 2, max = 10)
      ),
      conditionalPanel(
        condition = "input.method == 'DBSCAN'",
        sliderInput("eps",
                    "distance threshold (eps)",
                    min = 0.1,
                    max = 5,
                    value = 0.5,
                    step = 0.1),
        numericInput("minpts", "MinPts:", value = 5, min = 1, max = 50)
      ),
      conditionalPanel(
        condition = "input.method == 'hierarchical'",
        selectInput("linage", "link_methods:",
                    choices = c("complete", "single", "avarage", "ward.D2"))
      ),

      # кнопка анализа
      actionButton("run", "Run Analysys")
    ),

    # главная часть UI
    mainPanel(
      plotOutput("cluster_Plot"),
      tableOutput("summury"),
      textOutput("info")
    )
  )
)
