# Copyright 2020 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

#Set date and time for output directory
DataTimeStamp <- format(Sys.time(), format="%d_%B_%Y_%H_%M")
dataOutDirTS<-file.path(dataOutDir,DataTimeStamp)
dir.create(file.path(dataOutDirTS), showWarnings = FALSE)
#dataOutDirTS<-'out/data/GD_Base/30_January_2023_14_22'
#Load Files
SampleStrataIn<-readRDS('tmp/SampleStrataIn')
SampleStrataM<-readRDS(file = 'tmp/SampleStrataR')
ScoreCard_2022<-readRDS(file = file.path(paste0('tmp/',ScoreCardFileName,'_2022',sep='')))
ScoreCard_2023<-readRDS(file = file.path(paste0('tmp/',ScoreCardFileName,'_2023',sep='')))
Wetlands <- st_read(file.path(spatialOutDir,"Wetlands.gpkg"))
#Wetlands <- st_read(file.path(spatialOutDir,"SampleStrata2022.gpkg"))
#write_sf(Wetlands,file.path(dataOutDirTS,"WetlandsC.gpkg"),layer_options='overwrite=TRUE')
#write_sf(Wetlands,file.path(dataOutDirTS,"SampleStrata2022.gpkg"),layer_options='overwrite=TRUE')

#SampleStrataM <- st_read(file.path(dataOutDirTS,"SamplesGeo.gpkg")) %>% dplyr::select(Wetland_Co, Sampled, SamplePriority, YearSampled, SampleType, all_of(Requ))

#SampleStrataMO <- st_read(file.path(dataOutDirTS,"FromOne/SamplesGeo.gpkg"))

#,-c(all_of(Requ),Sampled,SampleType,YearSampled))

#SampleStrataOut1<- SampleStrataIn %>%
#  dplyr::filter(!WTLND_ID %in% SampleStrataM$WTLND_ID)

#SampleStrataOut<-rbind(SampleStrataOut1, SampleStrataM)

#Grab input data not used for sample draw and output full data set
SampleStrataOut<- SampleStrataIn %>%
  dplyr::select(-c(all_of(Requ),Sampled,SampleType,YearSampled)) %>%
  right_join(SampleStrataM, by=c('Wetland_Co')) %>%
  dplyr::filter(as.numeric(Sampled)==1) %>%
  dplyr::select(Wetland_Co, Sampled, SamplePriority,YearSampled, SampleType,
                pct_private_ovlp, all_of(Requ))

WetData<-list(SampleStrataOut, ScoreCard_2023, ScoreCard_2022)
WetDataNames<-c('Wetlands To Sample','ScoreCard_2023','ScoreCard_2022')

WriteXLS(WetData,file.path(dataOutDirTS,paste(WetlandAreaShort,'_WetlandDraw.xlsx',sep='')),SheetNames=WetDataNames)

#Output spatial version of samples and full sample set
SampleStrataOut<- SampleStrataIn %>%
  dplyr::select(-c(all_of(Requ),Sampled,SampleType,YearSampled)) %>%
  right_join(SampleStrataM, by=c('Wetland_Co'))

#Full spatial
SampleStrataGeo<-Wetlands %>%
  mutate(Wetland_Co=WTLND_ID) %>%
  dplyr::select(Wetland_Co) %>%
  #mutate(Wetland_Co=as.character(Wetland_Co)) %>%
  left_join(SampleStrataOut) %>%
  st_cast("POLYGON")
  #lwgeom::st_snap_to_grid(0.1) %>%
  #st_make_valid()

table(SampleStrataGeo$Sampled,SampleStrataGeo$YearSampled)

write_sf(SampleStrataGeo,file.path(dataOutDirTS,"SampleStrataGeo.gpkg"),delete_dsn=TRUE)
st_write(SampleStrataGeo, file.path(dataOutDirTS,"SampleStrataGeo.shp"),delete_dsn=TRUE)
#st_write(SampleStrataGeo, file.path(dataOutDirTS,"SampleStrataGeo.GeoJSON"),delete_dsn=TRUE)
#Spatial only sample sites
SamplesGeo<-SampleStrataGeo %>%
  dplyr::filter(Sampled==1) %>%
  lwgeom::st_snap_to_grid(0.1) %>%
  st_make_valid()
write_sf(SamplesGeo,file.path(dataOutDirTS,"SamplesGeo.gpkg"),delete_dsn=TRUE,delete_layer=TRUE)
st_write(SamplesGeo, file.path(dataOutDirTS,"SamplesGeo.shp"),delete_dsn=TRUE)
#st_write(SamplesGeo, file.path(dataOutDirTS,"SamplesGeo.GeoJSON"), delete_dsn=TRUE)
#KML versions
Samples2022_KML <- SamplesGeo %>%
  dplyr::filter(as.numeric(YearSampled) < 2023 & as.numeric(YearSampled)>0) %>%
  st_transform(crs="+proj=longlat +datum=WGS84") %>%
  mutate(NAME = Wetland_Co) # see https://gdal.org/drivers/vector/kml.html#creation-options
#as_Spatial() %>%
  #writeOGR(dsn=file.path(dataOutDir,"Wetland_2021_Sample.kml"), layer= "Wetland_2021_Sample", driver="KML", overwrite_layer=TRUE)
  st_write(Samples2022_KML, file.path(dataOutDirTS,"Wetland_2022_Sample.kml"), driver = "kml")#, delete_dsn = TRUE) #Writing to a fresh directory every time

Samples2023_KML <- SamplesGeo %>%
  dplyr::filter(as.numeric(YearSampled) == 2023) %>%
  st_transform(crs="+proj=longlat +datum=WGS84") %>%
  mutate(NAME = Wetland_Co) # see https://gdal.org/drivers/vector/kml.html#creation-options
#as_Spatial() %>%
  #writeOGR(dsn=file.path(dataOutDir,"Wetland_2022_Sample.kml"), layer= "Wetland_2022_Sample", driver="KML", overwrite_layer=TRUE)
#st_write(Samples2023_KML, file.path(dataOutDirTS,"Wetland_2023_Sample.kml"), driver = "kml")#, delete_dsn = TRUE)
st_write(Samples2023_KML, file.path(dataOutDirTS,"Wetland_2023_Sample.kml"), driver = "kml")#, delete_dsn = TRUE)

#dataOutDirTS<-"out/data/Sub_Boreal/02_February_2023_13_16"
SamplesGeo<-st_read(file.path(dataOutDirTS,"SamplesGeo.gpkg"))
st_write(SamplesGeo, file.path(dataOutDirTS,"SamplesGeo.shp"),delete_dsn=TRUE)
SampleStrataGeo<-st_read(file.path(dataOutDirTS,"SampleStrataGeo.gpkg"))
st_write(SampleStrataGeo, file.path(dataOutDirTS,"SampleStrataGeo.shp"),delete_dsn=TRUE)



#change permissions - not working?
#Sys.umask("006")
#UF.NBR.data<-read_csv(file.path(dataOutDir,paste0('UF.NBR.data.data.csv')))
#file.mode(file.path(dataOutDir,paste0('UF.NBR.data.data.csv')))
#(file.path(dataOutDir,paste0('UF.NBR.data.data.csv')))
#Sys.umask("644")
#write_csv(UF.NBR.data,file.path(dataOutDir,paste0('UF.NBR.data.data1.csv')))
#file.mode(file.path(dataOutDir,paste0('UF.NBR.data.data1.csv')))


#st_write(UF.HL.v,file.path(spatialOutDir,"UF.HL.v.gpkg"))
#> write.csv(data.frame(a = 1:3), file = "/tmp/test.csv")
#> file.mode("/tmp/test.csv")
#[1] "644"
# Setting the umask results in succes:
#Sys.umask("006")
#> write.csv(data.frame(a = 1:3), file = "/tmp/test2.csv")
#> file.mode("/tmp/test2.csv")
#[1] "660"


