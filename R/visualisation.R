# Содержимое R/visualisation.R
plot_clusters_kmeans <- function(data, model) {
  require(factoextra)
  fviz_cluster(list(data = scale(data), cluster = model$cluster)) +
    ggtitle("K-Means Clustering Results")
}
plot_clusters_dbscan <- function(data, model) {
  require(factoextra)
  fviz_cluster(list(data = scale(data), cluster = model$cluster)) +
    ggtitle("DBSCAN Clustering Results")
}
plot_clusters_hclust <- function(data, result) {
  require(factoextra)
  fviz_cluster(list(data = scale(data), cluster = result$cluster)) +
    ggtitle("Hierarchical Clustering Results") +
    theme_minimal()
}

