# Файл для установки R-зависимостей
install.packages("readr")   #  для эффектинвой обработки и очитки данных
install.packages("ggplot2")    # визуализация
install.packages("dplyr")      # манипуляции с данными
install.packages("cluster")      # для проведения кластеризации kmeans,
#  pam, clara и красивой визуализации.
install.packages("factoextra")
install.packages("clValid") # Для определения оптимального числа кластеров
install.packages("NBCludt") # Для определения оптимального числа кластеров
install.packages("reticulate") # ВАЖНО: для работы с Python из R!

install.packages("writexl") # для сохранения результатов в exl
#  для можно булет попробовтаь еше openxlsx