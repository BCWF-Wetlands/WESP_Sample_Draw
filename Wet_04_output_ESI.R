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

#Write out updated 2020 sampling data by Nation
SampleStrataM<-readRDS(file = 'tmp/SampleStrataR')

#Grab input data not used for sample draw and output full data set
SampleStrataOut<- SampleStrataIn %>%
  dplyr::select(-c(Requ), -c(names(SampleCols))) %>%
  right_join(SampleStrataM, by=c('Wetland_Co')) %>%
  dplyr::filter(Sampled==1)

ScoreCardR<-readRDS(file = 'tmp/ScoreCardR')

WetData<-list(SampleStrataOut, ScoreCardR)
WetDataNames<-c('Wetlands To Sample','ScoreCard')

WriteXLS(WetData,file.path(dataOutDir,paste(WetlandArea,'_WetlandDraw.xlsx',sep='')),SheetNames=WetDataNames)

