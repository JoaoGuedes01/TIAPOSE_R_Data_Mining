FROM rocker/r-ver

RUN apt-get update -qq && \
    apt-get install -y \
        pandoc \
        libssl-dev \
        libcurl4-gnutls-dev \
        libxml2-dev \
        libglib2.0-0

RUN R -e "install.packages(c('rminer','forecast','tidyverse','plumber','dplyr','plotly'))"

COPY . .

EXPOSE 8000

ENTRYPOINT ["R", "-e","library(plumber); plumb('serverRouting.R')$run(port=8000)"]