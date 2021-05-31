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
SampleFileName<-'BCWF/GD_Wetlands_May31.csv'

#Sample Column names - to be added if not present,
#note if sample columns present should be renamed to these
SampleCols <- c(Sampled = "", YearSampled = "", SampleType = "")

#Read in file and add sampling columns if not already present
SampleStrataIn<-read_csv(file.path(DataDir,SampleFileName), na="NA") %>%
  #set up some new fields to be populated by the sample selection if not already selected
  add_column(!!!SampleCols[!names(SampleCols) %in% names(.)]) %>%
  mutate(Wetland_Co=fid) %>%
  #convert all to character
  mutate_all(as.character)

#get column names to populate the Requ list
colnames(SampleStrataIn)

##Make a list of what attributes to populate the score card
Requ<-c("stream_intersect" , "river_intersect", "mmwb_intersect", "lake_intersect",
        "split_by_stream",  "stream_start", "stream_end", "Verticalflow", "Bidirectional",
        "Throughflow", "Outflow", "Inflow","max_stream_order", "granitic_bedrock",
        "Land_Cover", "Land_Disturbance", "BEC")


#Prepare the SampleStrata data and apply any filters
SampleStrata<-SampleStrataIn %>%
  #filter out wetlands >500m from a road
  dplyr::filter(dist_to_road=="<= 500m") %>%
  #select fields used for establishing requirements and if sampled
  dplyr::select(Wetland_Co=fid, Sampled, YearSampled, SampleType, all_of(Requ))

SampleStrata[is.na(SampleStrata)] <- "unknown"

saveRDS(SampleStrata, file = 'tmp/SampleStrata')

#Set variables for selection
NWetsToSample<-100 #have to adjust NReplicates for now
NReplicates<-20
minSampled<-1

source("Wet_02_clean_data.R")

source("Wet_03.1_analysis_ReportCard_1.R")
source("Wet_03.2_analysis_SampleRequirements.R")

source("Wet_04_output_BCWF.R")

