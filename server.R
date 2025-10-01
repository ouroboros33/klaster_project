output$clusterPlot <- renderPlot({
  data <- read.csv(input$file$datapath)  # читаем загруженный файл
  # вызываем тут свою функцию кластеризации
  # строим график
})
output$summary <- renderTable({
  head(read.csv(input$file$datapath))
})
observeEvent(input$run, {
  # код запускается только при нажатии кнопки
  data <- read.csv(input$file$datapath)
  result <- run_kmeans(data, input$k)
  output$clusterPlot <- renderPlot({
    plot_clusters_kmeans(data, result)
  })
})

observeEvent(input$run, {
  data <- read.csv(input$file$datapath)
  if (input$method == "K-means") {
    result <- run_kmeans(data, input$k)
    output$cluster_Plot <- renderPlot({ plot_clusters_kmeans(data, result) })
  } else if (input$method == "DBSCAN") {
    result <- run_dbscan(data, eps = input$eps, minPts = input$minpts)
    output$cluster_Plot <- renderPlot({ plot_clusters_dbscan(data, result) })
  } else {
    result <- run_hclust(data)
    output$clusterPlot <- renderPlot({ plot_clusters_hclust(data, result) })
  }
})