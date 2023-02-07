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

#Generates 2019/2020 report card from plot data

SampleStrata<-readRDS(file='tmp/SampleStrata')

#Use a function to get #categories, #wets
RequireFn <- function(dataset, RequireNIn){
  dataset %>%
    group_by_(.dots=requs[RequireNIn,2]) %>%
    dplyr::summarise(nSampled=sum(as.integer(Sampled)), nWets=n()) %>%
    dplyr::rename(setNames(requs[RequireNIn,2], 'Requirement')) %>%
    dplyr::mutate(ReqGroup=RequireNIn) %>%
    mutate(ReqGroupName=requs[RequireNIn,2])%>%
    mutate(ReqTarget=requs[RequireNIn,3])%>%
    dplyr::select(ReqGroup, ReqGroupName, Requirement,nWets, nSampled,ReqTarget)
}

df<-lapply(requs[,1], function(i) RequireFn(SampleStrata, i))
ScoreCard_2022<-ldply(df,data.frame)

saveRDS(ScoreCard_2022, file = file.path(paste0('tmp/',ScoreCardFileName,'_2022')))

WriteXLS(ScoreCard_2022,file.path(dataOutDir,paste(ScoreCardFileName,'_2022.xlsx',sep='')))

#Figure out sampling priority
SP_df<-ScoreCard_2022 %>%
  mutate(SamplePriority1=findInterval(nSampled,
  round(quantile(ScoreCard_2022$nSampled, probs = seq(0, 0.9, by = .01))))) %>%
  dplyr::select(nSampled,SamplePriority1) %>%
  group_by(SamplePriority1) %>%
  dplyr::summarize() %>%
  mutate(SamplePriority=order(SamplePriority1))

SampleP<-ScoreCard_2022 %>%
  mutate(SamplePriority1=findInterval(nSampled,
  round(quantile(ScoreCard_2022$nSampled, probs = seq(0, 0.9, by = .01))))) %>%
  left_join(SP_df) %>%
  dplyr::select(Requirement, ReqGroupName,SamplePriority)


#add SamplePriority to 2023 score card
#ScoreCard_2023 <- ScoreCard_2023 %>%
#  left_join(SamplePriority)



