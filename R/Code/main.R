### Reproducible Research Fundamentals -  Main R Script

# Load libraries ---- 

# Load necessary libraries
library(renv)
#renv::init()
library(haven)  # for reading .dta files
library(dplyr)  # for data manipulation
library(tidyr)  # for reshaping data
library(stringr) # work with strings
library(labelled) # use labels
library(gtsummary) # tables
library(gt) # tables
library(ggplot2) #graphs
library(tidyverse) # working with tidy data
library(modelsummary) # creating summary tables
library(stargazer) # writing nice tables
library(RColorBrewer) # color palettes

#Recover environment---

#New users need to restore the environment by running this code:
#you only need to do this the first time you run the package.
#renv::restore()

# Set data path ----

# this is the second root of the project, the first root is the code whose directory 
# is already being handled by the rstudio project.

data_path <- "/Users/estebanorozco/Documents/DataWork/Data"

# Run the R scripts ----

source("/Users/estebanorozco/Documents/GitHub/rrf24_training_esteban/R/Code/01-processing-data.R")
source("/Users/estebanorozco/Documents/GitHub/rrf24_training_esteban/R/Code/02-constructing-data.R")
source("/Users/estebanorozco/Documents/GitHub/rrf24_training_esteban/R/Code/03-analyzing-data.R")
