library(shiny)
library(dplyr)
library(readr)
library(cluster)    # для silhouette, если используете evaluate_clustering
library(factoextra)
library(dbscan)
thematic_shiny()
# ВАЖНО: убедитесь, что функции из R/Clustering_methods.R и R/visualisation.R
# корректно подключаются (вы уже делаете source() в global.R)

server <- function(input, output, session) {

  # реактивное хранилище для исходных данных
  dataset <- reactiveVal(NULL)

  # загрузка CSV по событию input$file
  observeEvent(input$file, {
    req(input$file)
    tryCatch({
      data <- readr::read_csv(input$file$datapath, show_col_types = FALSE)
      # убираем нечисловые пОшибка при чтении файларизнаки — k-means/DBSCAN требуют чисел
      num_data <- dplyr::select_if(data, is.numeric)

      if (ncol(num_data) == 0) {
        showNotification(
          "The downloaded file does not contain 
          any numeric columns for clustering.",
          type = "error"
        )
        dataset(NULL)
      } else {
        dataset(num_data)
      }
    },
    error = function(e) {
      showNotification(
        paste("Error while reading file:", e$message),
        type = "error"
      )
      dataset(NULL)
    })
  })

  # краткая сводка по данным
  output$dataSummary <- renderPrint({
    data <- dataset()
    req(data)
    summary(data)
  })

  # запуск анализа по нажатию кнопки Run Analysis
  run_result <- eventReactive(input$run, {
    data <- dataset()
    validate(
      need(!is.null(data), "please, import CSV file with numeric data.")
    )

    method <- input$method

    switch(
      method,
      "K-means" = {
        model <- run_kmeans(data, k = input$k)
        list(
          method = "K-means",
          model = model,
          cluster = model$cluster,
          plot = plot_clusters_kmeans(data, model)
        )
      },
      "DBSCAN" = {
        model <- run_dbscan(data, eps = input$eps, minPts = input$minpts)
        list(
          method = "DBSCAN",
          model = model,
          cluster = model$cluster,
          plot = plot_clusters_dbscan(data, model)
        )
      },
      "hierarchical" = {
        result <- run_hclust(data, linkage = input$linkage, k = input$k)
        list(
          method = paste("Hierarchical (", input$linkage, ")", sep = ""),
          model = result$model,
          cluster = result$cluster,
          plot = plot_clusters_hclust(data, result)
        )
      },
      {
        validate(FALSE, "Uknown clusterization method.")
      }
    )
  }, ignoreNULL = TRUE)

  # график кластеров
  output$cluster_Plot <- renderPlot({
   image(volcano, col = thematic_get_option("sequential"))
    res <- run_result()
    req(res$plot)
    res$plot
  })

  # таблица со сводной статистикой по кластерам
  output$summary <- renderTable({
    res <- run_result()
    req(res$cluster)
    data <- dataset()
    req(data)
    dplyr::bind_cols(data, cluster = res$cluster) %>%
      dplyr::group_by(cluster) %>%
      dplyr::summarise(
        dplyr::across(
          .cols = everything(),
          .fns = list(mean = mean, sd = sd),
          .names = "{.col}_{.fn}"
        ),
        .groups = "drop"
      )
  })

  # текстовая информация, метрики качества
  output$info <- renderPrint({
    res <- run_result()
    req(res$cluster)
    data <- dataset()
    req(data)

    if (res$method == "DBSCAN") {
      metrics <- evaluate_clustering(data, res$cluster)
      cat(
        "Method:", res$method, "\n",
        "Number of clusters (without noise):", metrics$n_clusters, "\n",
        "Silhouette:", metrics$silhouette, "\n",
        "noise %:", metrics$noise_ratio, "\n"
      )
    } else {
      metrics <- evaluate_clustering(data, res$cluster)
      cat(
        "Method:", res$method, "\n",
        "Number of clusters:", metrics$n_clusters, "\n",
        "Silhouette:", metrics$silhouette, "\n"
      )
    }
  })

  # обработчик кнопки Exit
  observeEvent(input$exit, {
    stopApp()
  })
}