library(shiny)
library(shinythemes)

server <- function(input, output, session) {
  output$summary <- renderTable({
    req(input$file)
    head(read.csv(input$file$datapath))
  })
  # Основной обработчик кнопки "Run Analysis"
  observeEvent(input$run, {
    req(input$file)
    
    data <- read.csv(input$file$datapath)
    data <- data %>% select_if(is.numeric)
    
    if (input$method == "K-means") {

      result <- run_kmeans(data, input$k)
      output$cluster_Plot <- renderPlot({
        plot_clusters_kmeans(data, result)
      })
      # --- Оценка ---
      metrics <- evaluate_clustering(data, result$cluster)
      output$info <- renderText({
        paste0(
          "Method: K-means\n",
          "Number of clusters: ", metrics$n_clusters, "\n",
          "Avg silhouette: ", metrics$silhouette
        )
      })
      
    } else if (input$method == "DBSCAN") {
      result <- run_dbscan(data, eps = input$eps, minPts = input$minpts)
      output$cluster_Plot <- renderPlot({
        plot_clusters_dbscan(data, result)
      })
      metrics <- evaluate_clustering(data, result$cluster)
      output$info <- renderText({
        paste0(
          "Method: DBSCAN\n",
          "Clusters (without noise): ", metrics$n_clusters, "\n",
          "Nois dots: ", metrics$noise_ratio, "%\n",
          "Avg silhouette: ", metrics$silhouette
        )
      })
      
    } else if (input$method == "hierarchical") {
      linkage <- input$linkage
      result <- run_hclust(data, linkage, k = input$k)
      output$cluster_Plot <- renderPlot({
        plot_clusters_hclust(data, result)
      })
      metrics <- evaluate_clustering(data, result$cluster)
      output$info <- renderText({
        paste0(
          "Method: Hierarchical (", linkage, ")\n",
          "Number of clusters: ", metrics$n_clusters, "\n",
          "Avg silhouette: ", metrics$silhouette
        )
      })
    }
  })
}