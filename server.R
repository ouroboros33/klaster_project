library(shiny)
library(dplyr)
library(readr)
library(cluster)
library(factoextra)
library(dbscan)

server <- function(input, output, session) {

  dataset <- reactiveVal(NULL)
  built_plots <- reactiveVal(list())

  observeEvent(input$file, {
    req(input$file)
    tryCatch({
      data <- readr::read_csv(input$file$datapath, show_col_types = FALSE)
      numeric_data <- dplyr::select(data, where(is.numeric))

      if (ncol(numeric_data) == 0) {
        showNotification(
          "There is no numeric data for clustering.",
          type = "error"
        )
        dataset(NULL)
      } else {
        dataset(numeric_data)
      }
    }, error = function(e) {
      showNotification(
        paste("Read data error:", e$message),
        type = "error"
      )
      dataset(NULL)
    })
  })

  output$dataSummary <- renderPrint({
    req(dataset())
    summary(dataset())
  })

  run_result <- eventReactive(input$run, {
    data <- dataset()
    validate(
      need(!is.null(data), "Please, import CSV-file with data")
    )

    method <- input$method

    switch(
      method,
      "K-means" = {
        model <- run_kmeans(data, k = input$k)
        list(
          method = "K-means",
          cluster = model$cluster,
          plot = plot_clusters_kmeans(data, model)
        )
      },
      "DBSCAN" = {
        model <- run_dbscan(data, eps = input$eps, minPts = input$minpts)
        list(
          method = "DBSCAN",
          cluster = model$cluster,
          plot = plot_clusters_dbscan(data, model)
        )
      },
      "hierarchical" = {
        result <- run_hclust(data, linkage = input$linkage, k = input$k)
        list(
          method = paste0("Hierarchical (", input$linkage, ")"),
          cluster = result$cluster,
          plot = plot_clusters_hclust(data, result)
        )
      },
      {
        validate(FALSE, "Unknowm method of clustering")
      }
    )
  }, ignoreNULL = TRUE)

  observeEvent(run_result(), {
    res <- run_result()
    plots <- built_plots()
    tab_title <- sprintf("Plot %d – %s", length(plots) + 1, res$method)
    plots[[tab_title]] <- res$plot
    built_plots(plots)
  })

  output$plots_tabset <- renderUI({
    plots <- built_plots()
    if (length(plots) == 0) {
      return(h4("No plots yet."))
    }

    tabs <- lapply(seq_along(plots), function(i) {
      tabPanel(
        title = names(plots)[i],
        plotOutput(outputId = paste0("cluster_plot_", i), height = "420px")
      )
    })

    do.call(tabsetPanel, c(list(id = "cluster_plots_tabs", type = "tabs"), tabs))
  })

  observe({
    plots <- built_plots()
    lapply(seq_along(plots), function(i) {
      local({
        idx <- i
        output[[paste0("cluster_plot_", idx)]] <- renderPlot({
          req(built_plots())
          built_plots()[[idx]]
        })
      })
    })
  })

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

  output$info <- renderPrint({
    res <- run_result()
    req(res$cluster)
    data <- dataset()
    req(data)

    metrics <- evaluate_clustering(data, res$cluster)

    cat(
      "Method:", res$method, "\n",
      "Number of clusters:", metrics$n_clusters, "\n",
      "Silhouette:", metrics$silhouette, "\n"
    )

    if (res$method == "DBSCAN") {
      cat("Noise (%):", metrics$noise_ratio, "\n")
    }
  })

  observeEvent(input$exit, {
    stopApp()
  })
}