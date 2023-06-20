# Copyright 2018 Province of British Columbia
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

source("header.R")

#Select an EcoProvince(s)
#one of: 1-SIM, 2-TBP, 3-SB, 4-GD, 5-GD_Est, 6-SB_PEM
EcoP<-4

WetlandArea<-WetlandAreaL[EcoP]
WetlandAreaDir<-WetlandAreaDirL[EcoP]
WetlandAreaShort<-WetlandAreaShortL[EcoP]
EcoPN<-as.character(EcoPNL[EcoP])
#For Plains use:
# EcoPN<-c("BOREAL PLAINS","TAIGA PLAINS")

#Set up unique directories for EcoProvince output
dataOutDir <- file.path(OutDir,'data',WetlandAreaDir)
figsOutDir <- file.path(OutDir,'figures',WetlandAreaDir)
DataDirYear <- file.path('data',MonitoringSeason,WetlandAreaDir)
spatialOutDir <- file.path('../WESP_data_prep/out','spatial',WetlandAreaDir)
dir.create(file.path(dataOutDir), showWarnings = FALSE)
dir.create(DataDir, showWarnings = FALSE)

#Expects a csv files of wetlands
SampleFileName<-paste0('SampleStrata_2022_',WetlandAreaShort,'.csv')
outFileN<-paste0('SampleStrata_2022_',WetlandAreaShort,'.csv')

#Sample Column names - to be added if not present,
#note if sample columns present should be renamed to these, may need to add partner_size
SampleCols <- c(Sampled = NA, YearSampled = NA, SampleType = NA, partner_site="", pct_private_ovlp=NA)
#Add in columns for EcoProvince's that dont have
OtherColumns<-c(parcelmap_private=NA,partner_site=NA)

#Read in file and add sampling columns if not already present
SampleStrataIn<-read_csv(file.path(DataDir,SampleFileName), na="NA") %>%
  #set up some new fields to be populated by the sample selection if not already selected
  add_column(!!!SampleCols[!names(SampleCols) %in% names(.)]) %>%
  add_column(!!!OtherColumns[!names(OtherColumns) %in% names(.)]) %>%
  mutate(Wetland_Co=WTLND_ID) %>%
  #convert all to character
  mutate_all(as.character) %>%
  mutate_at(c("Sampled","SampleType","YearSampled"), as.numeric)
saveRDS(SampleStrataIn, file = 'tmp/SampleStrataIn')

#get column names to populate the Requ list
colnames(SampleStrataIn)

##Make a list of what attributes to populate the score card
#Requ<-c("stream_intersect" , "river_intersect", "mmwb_intersect", "lake_intersect",
#        "split_by_stream",  "stream_start", "stream_end", "Verticalflow", "Bidirectional",
#        "Throughflow", "Outflow", "Inflow", "granitic_bedrock",
#        "Land_Cover", "Land_Disturbance", "BEC", "FlowCode","LakeSize")

#Set variables for selection
NWetsToSample<-100 #have to adjust NReplicates for now
NReplicates<-4
minSampled<-0

#Requ<-c("stream_intersect" , "river_intersect", "mmwb_intersect", "lake_intersect",
#        "split_by_stream",  "stream_start", "stream_end", "Verticalflow", "Bidirectional",
#        "Throughflow", "Outflow", "Inflow", "granitic_bedrock",
#        "Land_Cover", "Land_Disturbance", "BEC", "FlowCode","LakeSize")

Requ1<-c("stream_intersect" , "river_intersect", "mmwb_intersect", "lake_intersect",
        "split_by_stream",  "stream_start", "stream_end", "Verticalflow", "Bidirectional",
        "Throughflow", "Outflow", "Inflow", "granitic_bedrock",
        "LandCoverType", "DisturbType","RdDisturbType","LakeSize")
RequT1<-rep(c(NReplicates),times=length(Requ1))

#Default
#Requ2<-c("BEC", "FlowCode")
#RequT2<-c(15,15)
#For SIM
#Requ2<-c("BEC", "FlowCode", "Nation")
#RequT2<-c(15,15,25)
#For the Plains
Requ2<-c("BEC", "FlowCode", "LargeWetland")
RequT2<-c(15,15,3)

Requ<-c(Requ1, Requ2)
RequT<-c(RequT1, RequT2)

source("Wet_02_clean_data.R")
#Prepare the SampleStrata data and apply any filters

SampleStrata<-SampleStrataIn %>% #25973 for SIM
  #filter out wetlands >500m from a road
  #dplyr::filter(dist_to_road=="<= 500m" | (as.numeric(Sampled)==1)) %>%
  dplyr::filter(win500=="1" | (as.numeric(Sampled)==1)) %>% #16597
  #dplyr::filter(win50=="0" | (as.numeric(Sampled)==1)) %>% #11230
  dplyr::filter(!LandCoverType=="Water" | (as.numeric(Sampled)==1)) %>%
  #dplyr::filter(!(Wetland_Co %in% c('SIM_313','SIM_301'))| (as.numeric(Sampled)==1)) %>%
  #dplyr::filter(as.numeric(pct_private_ovlp) < 25 | (as.numeric(Sampled)==1)) %>% #11046
  #dplyr::filter(parcelmap_private == 'Yes' | Sampled==1) %>% #11046
  dplyr::filter(parcelmap_private == 'No' | partner_site  == 'Yes'|
                  as.numeric(pct_private_ovlp) < 25 | Sampled==1) %>% #11046
  #select fields used for establishing requirements and if sampled
  dplyr::select(Wetland_Co,Sampled, YearSampled, SampleType, all_of(Requ)) %>%
  #dplyr::select(Wetland_Co,Sampled, YearSampled, SampleType, partner_site, parcelmap_private, all_of(Requ)) %>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0)) %>%
  mutate_if(is.character, ~replace(., is.na(.), 'unknown')) %>%
  dplyr::filter(stream_intersect != 'unknown' | (as.numeric(Sampled)==1))

SampleCheck<-SampleStrata %>%
  dplyr::filter(stream_intersect=='unknown')
  #dplyr::filter(YearSampled==2021 | YearSampled==2022)
 # dplyr::filter(YearSampled>0)
nrow(SampleCheck)
table(SampleStrata$YearSampled)

tt<-SampleStrata %>%
  #dplyr::filter(as.numeric(Sampled)==1)
  #dplyr::filter(as.numeric(YearSampled)==2021)
  dplyr::filter(is.na(stream_intersect))

#ssCheck<-SampleStrata %>%
#  dplyr::filter(as.numeric(pct_private_ovlp) >= 25)

saveRDS(SampleStrata, file = 'tmp/SampleStrata')

ScoreCardFileName<-paste0(WetlandAreaShort,'_')

SampleCheck<-SampleStrata %>%
  #dplyr::filter(as.numeric(Sampled)==1)
  #dplyr::filter(YearSampled==2021 | YearSampled==2022)
  dplyr::filter(YearSampled>0)
nrow(SampleCheck)

source("Wet_03.1_analysis_ReportCard_1.R")

source("Wet_03.2_analysis_SampleRequirements.R")

source("Wet_04_output_BCWF.R")

