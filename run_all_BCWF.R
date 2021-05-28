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

#Name of Wetland Area
WetlandArea<-'Georgia Depression'

#Expects a csv files of wetlands
SampleFileName<-'BCWF/Wetlands_for_Don.csv'

#Read in file and get column names to populate the Requ list
SampleStrata<-read_csv(file.path(DataDir,SampleFileName), na="NA")
colnames(SampleStrata)

##Make a list of what attributes to populate the score card
Requ<-c("stream_intersect" , "river_intersect", "mmwb_intersect", "lake_intersect",
        "split_by_stream",  "stream_start", "stream_end", "Verticalflow", "Bidirectional",
        "Throughflow", "Outflow", "Inflow","granitic_bedrock", "Land_Cover", "Land_Disturbance", "BGC_Subzone")

#Prepare the SampleStrata data
SampleStrata<-SampleStrata %>%
  dplyr::select(Wetland_Co=fid, all_of(Requ)) %>%
  mutate(Sampled=0) %>%
  mutate(SampleType=0) %>%
  mutate(YearSampled=0) %>%
  #Change all requirements to character
  mutate_at(Requ, funs(as.character))


saveRDS(SampleStrata, file = 'tmp/SampleStrata')


#Set variables for selection
NWetsToSample<-100 #have to adjust NReplicates for now
NReplicates<-20
minSampled<-1

source("Wet_02_clean_data.R")

source("Wet_03.1_analysis_ReportCard_1.R")
source("Wet_03.2_analysis_SampleRequirements.R")

source("Wet_04_output.R")

