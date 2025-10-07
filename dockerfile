# Image R & Shiny Server
FROM rocker/shiny:4.3.1

# Системные зависимости и полезные утилиты
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libtiff5-dev \
    libjpeg-dev \
    libpng-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    && rm -rf /var/lib/apt/lists/*

# Установка пакетов с обработкой ошибок
RUN R -e "install.packages('remotes', repos='https://cloud.r-project.org/')"

# Сначала основные пакеты
RUN R -e "install.packages(c(\
  'shiny', 'ggplot2', 'plotly', 'dbscan', 'dplyr', \
  'readr', 'shinythemes', 'cluster', 'datasets', \
  'ggpubr', 'factoextra'\
), repos='https://cloud.r-project.org/')"

# Если factoextra не устанавливается, попробуем через remotes
RUN R -e "if(!require('factoextra')) remotes::install_version('factoextra', '1.0.7')"

# Copy project into container
COPY . /srv/shiny-server/

# Work directory
WORKDIR /srv/shiny-server/

# Open port Shiny Server (standard 3838)
EXPOSE 3838

# Start command
CMD ["/usr/bin/shiny-server"]