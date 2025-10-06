# Image R & Shiny Server
FROM rocker/shiny:4.3.1

# Cистемные зависимости и полезные утилиты
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libtiff5-dev \
    libjpeg-dev \
    libpng-dev \
    && rm -rf /var/lib/apt/lists/*

# R packages
RUN R -e "install.packages(c(\
  'shiny', 'ggplot2', 'plotly', 'dbscan', 'dplyr', \
  'readr', 'shinythemes', 'cluster', 'factoextra', 'datasets'\
), repos='https://cloud.r-project.org/')"

# Copy project into conteiner
COPY . /srv/shiny-server/

# work directory
WORKDIR /srv/shiny-server/

# Open port Shiny Server (standart 3838)
EXPOSE 3838

# start comand
CMD ["/usr/bin/shiny-server"]