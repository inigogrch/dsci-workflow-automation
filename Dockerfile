FROM rocker/rstudio:4.1.3

RUN apt update -y && \
    apt install -y libcurl4-openssl-dev libssl-dev libxml2-dev zlib1g-dev

RUN Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"

RUN Rscript -e "remotes::install_version('broom', version = '1.0.5', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('repr', version = '1.1.6', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('infer', version = '1.0.4', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('gridExtra', version = '2.3', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('faraway', version = '1.0.8', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('mltools', version = '0.3.5', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('leaps', version = '3.1', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('glmnet', version = '4.1.7', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('cowplot', version = '1.1.2', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('modelr', version = '0.1.11', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('tidyverse', version = '2.0.0', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('ggplot2', version = '3.4.3', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('dplyr', version = '1.1.3', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('GGally', version = '2.1.2', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('patchwork', version = '1.2.0', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('knitr', version = '1.42', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_github('DSCI-310/dsci-310-group-08')"

EXPOSE 8787

CMD ["/init"]