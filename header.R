
library(readr)
library(dplyr)
library(plyr)
library(WriteXLS)
library(readxl)

MonitoringSeason<-"2021"

OutDir <- 'out'
dataOutDir <- file.path(OutDir,'data')
figsOutDir <- file.path(OutDir,'figures')
DataDirYear <- file.path('data',MonitoringSeason)
DataDir <- file.path('data')

dir.create(file.path(OutDir), showWarnings = FALSE)
dir.create(file.path(dataOutDir), showWarnings = FALSE)
dir.create(DataDir, showWarnings = FALSE)
dir.create("tmp", showWarnings = FALSE)
