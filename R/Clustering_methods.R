run_kmeans <- function(data, k) {
  data_scaled <- scale(data)
  # Remove any remaining NA/NaN/Inf after scaling
  data_scaled <- data_scaled[complete.cases(data_scaled), ]
  if (nrow(data_scaled) < k) {
    stop("Not enough data points for k-means clustering")
  }
  kmeans(data_scaled, centers = k, nstart = 25)
}

run_dbscan <- function(data, eps = 0.5, minPts = 5) {
  data_scaled <- scale(data)
  data_scaled <- data_scaled[complete.cases(data_scaled), ]
  if (nrow(data_scaled) < minPts) {
    stop("Not enough data points for DBSCAN")
  }
  dbscan::dbscan(data_scaled, eps = eps, minPts = minPts)
}

run_hclust <- function(data, linkage = "ward.D2", k = 3) {
  data_scaled <- scale(data)
  data_scaled <- data_scaled[complete.cases(data_scaled), ]
  if (nrow(data_scaled) < 2) {
    stop("Not enough data points for hierarchical clustering")
  }
  d <- dist(data_scaled)
  hc <- hclust(d, method = linkage)
  cluster_assignments <- cutree(hc, k = k)
  list(model = hc, cluster = cluster_assignments)
}

evaluate_clustering <- function(data, labels) {
  # Handle case where all points are noise (DBSCAN)
  if (all(labels == 0)) {
    return(list(
      silhouette = NA,
      n_clusters = 0,
      noise_ratio = 100
    ))
  }
  # Remove noise points for silhouette calculation
  valid_labels <- labels[labels != 0]
  valid_data <- data[labels != 0, ]
  if (length(unique(valid_labels)) < 2 || nrow(valid_data) < 2) {
    return(list(
      silhouette = NA,
      n_clusters = length(unique(valid_labels)),
      noise_ratio = ifelse(any(labels == 0),
                           round(100 * sum(labels == 0) / length(labels), 2),
                           0)
    ))
  }
  
  tryCatch({
    data_scaled <- scale(valid_data)
    data_scaled <- data_scaled[complete.cases(data_scaled), ]
    valid_labels <- valid_labels[complete.cases(scale(valid_data))]
    
    if (length(unique(valid_labels)) < 2) {
      return(list(
        silhouette = NA,
        n_clusters = length(unique(valid_labels)),
        noise_ratio = ifelse(any(labels == 0),
                             round(100 * sum(labels == 0) / length(labels), 2),
                             0)
      ))
    }
    
    sil <- cluster::silhouette(valid_labels, dist(data_scaled))
    avg_sil <- mean(sil[, 3])
    
    list(
      silhouette = round(avg_sil, 3),
      n_clusters = length(unique(valid_labels)),
      noise_ratio = ifelse(any(labels == 0),
                           round(100 * sum(labels == 0) / length(labels), 2),
                           0)
    )
  }, error = function(e) {
    list(
      silhouette = NA,
      n_clusters = length(unique(valid_labels)),
      noise_ratio = ifelse(any(labels == 0),
                           round(100 * sum(labels == 0) / length(labels), 2),
                           0)
    )
  })
}