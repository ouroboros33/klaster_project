library("shiny") # сам фреймворк для UI + Server.
library("ggplot2") # для красивой визуализации.
library("plotly")
library("dbscan") # метод DBSCAN.
library("stats") # для k-means и иерархической кластеризации.
library("dplyr") # удобная работа с данными. //
library("readr") # для загрузки CSV.
library("shinythemes") # для красивых тем UI 
library("factoextra")

# подключение своих функций
source("R/Clustering_methods.R")
source("R/visualisation.R")

# тестовые данные
# default_data <- read.csv("data/customers.csv")

