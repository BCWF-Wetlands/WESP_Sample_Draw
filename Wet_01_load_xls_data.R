## Demo 1.

# determine sampling points for a fish monitoring survey

source('header.R')

#Names of tabs in data spreadsheet
WetSampleSheets<- excel_sheets(file.path(DataDir,'WetSampleData.xlsx'))
SampleStrata<-read_excel(file.path(DataDir,'WetSampleData.xlsx'),
                         sheet = WetSampleSheets[1])
saveRDS(SampleStrata, file = 'tmp/SampleStrata')

wet_site_1<-read_excel(file.path(DataDir,'WetSampleData.xlsx'),
                         sheet = WetSampleSheets[2])
saveRDS(wet_site_1, file = 'tmp/wet_site_1')

SampleStrata<-SampleStrata %>%
  mutate(House_Name=ifelse(is.na(House_Name), 'Not Assigned', House_Name)) %>%
  dplyr::filter(Sampled==0)

write.csv(SampleStrata, file=file.path(DataDir,'SampleStrata_ESI.csv'), row.names = FALSE)
write.csv(wet_site_1, file=file.path(DataDir,'wet_site_1.csv'), row.names = FALSE)





