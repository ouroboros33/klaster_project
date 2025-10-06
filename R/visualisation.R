plot_clusters_kmeans <- function(data, model) {
  fviz_cluster(list(data = scale(data), cluster = model$cluster)) +
    ggtitle("K-Means Clustering Results")
}

plot_clusters_dbscan <- function(data, model) {
  fviz_cluster(list(data = scale(data), cluster = model$cluster)) +
    ggtitle("DBSCAN Clustering Results")
}

plot_clusters_hclust <- function(data, result) {
  fviz_cluster(list(data = scale(data), cluster = result$cluster)) +
    ggtitle("Hierarchical Clustering Results") +
    theme_minimal()
}