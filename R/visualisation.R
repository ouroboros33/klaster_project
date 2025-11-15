plot_clusters_kmeans <- function(data, model) {
  factoextra::fviz_cluster(list(data = scale(data), cluster = model$cluster)) +
    ggtitle("K-Means Clustering Results")
}

plot_clusters_dbscan <- function(data, model) {
  factoextra::fviz_cluster(list(data = scale(data), cluster = model$cluster)) +
    ggtitle("DBSCAN Clustering Results")
}

plot_dendrogram_hclust <- function(result) {
  hc <- result$model
  k  <- result$k
  factoextra::fviz_dend(
    hc,
    k = k,
    rect = TRUE,
    cex = 0.7
  ) + ggtitle("Hierarchical Clustering: Dendrogram")
}

plot_clusters_hclust <- function(data, result) {
  require(factoextra)
  fviz_cluster(list(data = scale(data), cluster = result$cluster)) +
    ggtitle("Hierarchical Clustering (PCA projection)") +
    theme_minimal()
}
