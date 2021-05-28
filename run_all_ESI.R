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

#Expects a csv files of wetlands
SampleFileName<-'SampleStrata_ESI.csv'

#Read in file and get column names
SampleStrata<-read_csv(file.path(DataDir,SampleFileName))
colnames(SampleStrata)

##Make a list of what attributes to populate the score card
Requ<-c('StrataGroup','WatershedID','House_Name','Verticalflow',
        'Bidirectional','Throughflow', 'Outflow', 'Inflow',
        'LanCoverLabel', 'DisturbType')

SampleStrata<-SampleStrata %>%
  dplyr::select(Wetland_Co, Sampled, SampleType, YearSampled,
                as.character(all_of(Requ))) %>%
                #Change all requirements to character
                mutate_at(Requ, funs(as.character))

saveRDS(SampleStrata, file = 'tmp/SampleStrata')

#Set variables for selection
NWetsToSample<-100 #have to adjust NReplicates for now
NReplicates<-4
minSampled<-1

source("Wet_02_clean_data.R")

source("Wet_03.1_analysis_ReportCard_1.R")
source("Wet_03.2_analysis_SampleRequirements.R")

#source("Wet_04_output.R")

