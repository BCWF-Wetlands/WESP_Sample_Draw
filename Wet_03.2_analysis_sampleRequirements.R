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

# Generates SampleStrataR file and updated score card
# has wetlands for sampling meeting requirements

SampleStrata<-readRDS(file='tmp/SampleStrata')

#Use a function to get #categories, #wets
RequireFn <- function(dataset, RequireNIn){
  dataset %>%
    group_by_(.dots=requs[RequireNIn,2]) %>%
    dplyr::summarise(nSampled=sum(Sampled), nWets=n()) %>%
    dplyr::rename(setNames(requs[RequireNIn,2], 'Requirement')) %>%
    dplyr::mutate(ReqGroup=RequireNIn) %>%
    mutate(ReqGroupName=requs[RequireNIn,2])%>%
    #mutate(MaxAvailable=nWets) %>%
    dplyr::select(ReqGroup, ReqGroupName, Requirement,nWets, nSampled)
}

########
setNames(requs[1,2], 'Requirement')
#######

#Make a list of what attributes to populate the score card and feed function

#### Start Loop  ####

#Set variables
SampleStrataR<-SampleStrata
NoSamples<-list()
#NumSampled<-1

#Initialize data frame that will hold sites that are to sampled
Wet_sampledR<-data.frame()

#Initialize a score card listing what requirement has been sampled
df<-lapply(requs[,1], function(i) RequireFn(SampleStrataR, i))
ScoreCardR<-ldply(df,data.frame)

#Loop through till NReplicates is met for all requirements or NWetsToSample is met
while ((minSampled < NReplicates)) {

 #Remove wetlands already sampled from the SampleStrata pool
   SampleStrataPool <- SampleStrataR %>%
    filter(Sampled == 0)

  #Take least common attribute of scorecard that hasn't been selected for sampling
  #However, skip those that where no more cases couldn't be found and are below NReplicates
  NewSampIn <- ScoreCardR %>%
    filter((nSampled < NReplicates) & nWets > nSampled) %>%
    filter(rank(nWets,ties.method="first")==1)

  #Test to see if a case was found, if not exit loop
  if (nrow(NewSampIn)>0) {

    NewSampleTest<-NewSampIn %>%
    left_join(SampleStrataPool, by = setNames(requs[NewSampIn$ReqGroup,2], 'Requirement')) %>%
    filter(rank(nWets,ties.method="random")==1)

#Test to make sure that something was selected
  #if (!is.na(NewSampleTest$Wetland_Co)) {

  #Now join with SampleStrata to get all the attributes
  #NewSample<-NewSamp %>%
  #  left_join(SampleStrataPool, by = setNames(requs[NewSampIn$ReqGroup,2], 'Requirement')) %>%
  #  filter(rank(nWets,ties.method="first")==1) %>%
  NewSample<-NewSampleTest %>%
    dplyr::rename(setNames('Requirement',requs[NewSampIn$ReqGroup,2])) %>%
    dplyr::sample_n(1) %>%
    mutate(Sampled=1) %>%
    mutate(SampleType=4) %>%
    mutate(YearSampled=2021) %>%
    dplyr::select(Wetland_Co, Sampled, SampleType, YearSampled, all_of(Requ))
  #Add to already selected wetlands
  Wet_sampledR <- rbind(Wet_sampledR,NewSample)
  #Update Sample pool with new site
  SampleStrataR$Sampled <- Wet_sampledR[match(SampleStrataR$Wetland_Co, Wet_sampledR$Wetland_Co),2]
  SampleStrataR$SampleType <- Wet_sampledR[match(SampleStrataR$Wetland_Co, Wet_sampledR$Wetland_Co),3]
  SampleStrataR$YearSampled <- Wet_sampledR[match(SampleStrataR$Wetland_Co, Wet_sampledR$Wetland_Co),4]
  #Set NA to 0
  SampleStrataR[is.na(SampleStrataR)] <- 0

  #Regenerate the score card
  df<-lapply(requs[,1], function(i) RequireFn(SampleStrataR, i))
  ScoreCardR<-ldply(df,data.frame) %>%
    dplyr::filter(!Requirement %in% NoSamples)

  #Check if have met nSampled for requirements
  minSampled<-min(ScoreCardR$nSampled)

  } else {

  minSampled<-NReplicates+1

  }
#get another wetland to sample
}

saveRDS(SampleStrataR, file = 'tmp/SampleStrataR')
saveRDS(ScoreCardR, file = 'tmp/ScoreCardR')


