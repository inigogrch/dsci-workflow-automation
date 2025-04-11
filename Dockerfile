# Use a compatible base image
FROM rocker/rstudio:4.3.1

# Update system packages and install dependencies in a single layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libgit2-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install remotes package first
RUN Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"

# Install tidyverse first to ensure its dependencies are properly resolved
RUN Rscript -e "install.packages('tidyverse', repos = 'https://cloud.r-project.org')"

# Install all necessary R packages for the project
RUN Rscript -e "\
    install.packages(c(\
      'docopt', \
      'GGally', \
      'broom', \
      'repr', \
      'infer', \
      'gridExtra', \
      'faraway', \
      'mitools', \
      'glmnet', \
      'cowplot', \
      'modelr', \
      'ggplot2', \
      'dplyr', \
      'patchwork', \
      'knitr', \
      'rmarkdown', \
      'markdown', \
      'pROC', \
      'testthat', \
      'here'\
    ), repos = 'https://cloud.r-project.org')"

# Install incomepredictability package from GitHub
RUN Rscript -e "remotes::install_github('DSCI-310-2025/incomepredictability', ref = 'main')"

# Create a global .Renviron file to disable renv autoloader for all users
RUN echo 'RENV_CONFIG_AUTOLOADER_ENABLED=FALSE' >> /usr/local/lib/R/etc/Renviron

# Verify installations
RUN Rscript -e "installed.packages()[,'Package']"

# Expose port 8787 for RStudio
EXPOSE 8787

# Start RStudio
CMD ["/init"]