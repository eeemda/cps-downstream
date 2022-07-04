# Metadata ####################################################################
# Name: 01_r_setup.R
# Author: Emmerich Davies <emmerich.davies@gmail.com>
# Purpose: Sets-up project for replication and download required R packages

# Install and load packages ##################################################

# check.packages function: install and load multiple R packages.
# Found this function here: https://gist.github.com/smithdanielle/9913897 on 2019/06/17
# Check to see if packages are installed. Install them if they are not, then load them into the R session.
check.packages <- function(pkg) {
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg)) {
          install.packages(new.pkg, dependencies = TRUE)
      }
    sapply(pkg, require, character.only = TRUE)
}

# List packages
packages <- c("dplyr", "foreign", "ggplot2", "ggmap", "grid", "gridExtra",
    "here", "readstata13", "readxl", "rgdal", "tmap", "xtable")

# Check if packages are installed and then load
check.packages(packages)

# Create folders ##############################################################

dir.create(file.path(here::here("data/output/figures")))
dir.create(file.path(here::here("data/output/tables")))
dir.create(file.path(here::here("data/output/text")))
dir.create(file.path(here::here("data/raw")))
dir.create(file.path(here::here("data/raw/qje")))
dir.create(file.path(here::here("data/raw/census")))
dir.create(file.path(here::here("data/clean")))
