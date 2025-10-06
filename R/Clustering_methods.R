run_kmeans <- function(data, k) {
  data_scaled <- scale(data)
  kmeans(data_scaled, centers = k, nstart = 25)
}

run_dbscan <- function(data, eps = 0.5, minPts = 5) {
  data_scaled <- scale(data)
  dbscan(data_scaled, eps = eps, minPts = minPts)
}

run_hclust <- function(data, linkage = "ward.D2", k = 3) {
  d <- dist(scale(data))
  hc <- hclust(d, method = linkage)
  cluster_assignments <- cutree(hc, k = k)
  list(model = hc, cluster = cluster_assignments)
}
evaluate_clustering <- function(data, labels) {
  if (length(unique(labels)) < 2) {
    return(list(
      silhouette = NA,
      n_clusters = length(unique(labels)),
      noise_ratio = ifelse(any(labels == 0),
                           sum(labels == 0) / length(labels), 0)
    ))
  }
  
  sil <- cluster::silhouette(labels, dist(scale(data)))
  avg_sil <- mean(sil[, 3])
  
  # Считаем число кластеров и долю шумовых точек
  list(
    silhouette = round(avg_sil, 3),
    n_clusters = length(unique(labels[labels != 0])),
    noise_ratio = ifelse(any(labels == 0),
                         round(100 * sum(labels == 0) / length(labels), 2),
                         0)
  )
} 