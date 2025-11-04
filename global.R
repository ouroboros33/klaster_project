library("shiny") # сам фреймворк для UI + Server.
library("ggplot2") # для красивой визуализации.
library("plotly")
library("dbscan") # метод DBSCAN.
library("stats") # для k-means и иерархической кластеризации.
library("dplyr") # удобная работа с данными. //
library("readr") # для загрузки CSV.    
library("shinythemes") # для красивых тем UI 
library("factoextra")
library("bslib") # замена shinythemes только с ручной настройкой
library("thematic")

# подключение своих функций
source("R/Clustering_methods.R")
source("R/visualisation.R")
source("www/custom.R")

# themes for plots
thematic::thematic_shiny(
  font = "Open Sans",
  bg = "#000000",
  fg = "#ffd700",
  accent = "#d40612"
)
# тестовые данные
# default_data <- read.csv("data/customers.csv")

