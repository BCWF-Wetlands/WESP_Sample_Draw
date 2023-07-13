
library(readr)
library(dplyr)
library(plyr)
library(WriteXLS)
library(readxl)
library(tibble)
library(sf)
library(rgdal)

MonitoringSeason<-"2022"

OutDir <- 'out'
DataDir <- file.path('data')
dir.create("tmp", showWarnings = FALSE)
dir.create(DataDir, showWarnings = FALSE)

WetlandAreaL<-list('SIM_Base',c('Taiga_Planes_Base','Boreal_Plains_Base'),
                   'Sub_Boreal','GD_Base','GD_Base_Est','Sub_Boreal_PEM','SI_Base')
WetlandAreaDirL<-c('SIM_Base','Taiga_Boreal_Plains',
                   'Sub_Boreal','GD_Base','GD_Base_Est','Sub_Boreal_PEM','SI_Base')
WetlandAreaShortL<-c('SIM','TBP',
                     'SB','GD','GD_Est','SB_PEM','SI')
EcoPNL<-list("SOUTHERN INTERIOR MOUNTAINS",c("BOREAL PLAINS","TAIGA PLAINS"),
             "SUB-BOREAL INTERIOR","GEORGIA DEPRESSION","GEORGIA DEPRESSION","SUB-BOREAL INTERIOR","SOUTHERN INTERIOR")



