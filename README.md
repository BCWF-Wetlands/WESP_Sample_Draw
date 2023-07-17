### Wetland Ecosystem Services Protocol (WESP) Sample Draw

<!-- Add a project state badge
See https://github.com/BCDevExchange/Our-Project-Docs/blob/master/discussion/projectstates.md
If you have bcgovr installed and you use RStudio, click the 'Insert BCDevex Badge' Addin. -->

# WESP_Sample_Draw
============================
The B.C. Wildlife Federation’s Wetlands Workforce project is a collaboration with conservation organizations and First Nations working to maintain and monitor wetlands across British Columbia.   
https://bcwf.bc.ca/initiatives/wetlands-workforce/.  

WESP - Wetland Ecosystem Services Protocol   

There are three sets of WESP R scripts to identify wetlands for monitoring within a study area.  
1) WESP_data_prep - presents a set of scripts used to generate a new, or process existing, wetlands for a study area - https://github.com/BCWF-Wetlands/WESP_data_prep;  
2) WESP_Sample_Design - attributes wetlands with local human and natural landscape characteristics - https://github.com/BCWF-Wetlands/WESP_Sample_Design; and    
3) WESP_Sample_Draw - This repository, Generates a report card of how samples are meeting sampling criteria and performs a draw to select wetlands to meet criteria.
   
### Usage

There are a set of scripts that conduct the sample draw from the wetlands, there are four basic sets of scripts:    
Control scripts - set up the analysis environment;   
Clean scripts - cleans generic wetlands and ecoprovince/study area specific wetlands;       
Analysis scripts - for ecoprovince wetlands that require additional processing; and     
Output scripts - output the attributed wetlands and the wetlands selected for sampling in gpkg and shapefile formats. As well, an excel table containing the wetlands to sample, and score card reporting how sampling criteria have been met.

#Control Scripts:   
run_all_BCWF.R	Sets local variables and directories used by scripts, presents script order and loads files from sample draw, including how many samples required for each sample requirement and overall size of calibration data set. Typically more than 100 requested in case some wetlands are un suitable for sampling, and  
header.R	loads R packages, sets global directories, and attributes

#Clean Scripts:   
Wet_02_clean_data.R	Cleans sample requirement data.  

#Analysis Scripts:   
Wet_03.1_analysis_ReportCard_1.R	Evalutes current samples and how they meet sampling requirements.   
Wet_03.2_analysis_SampleRequirements.R	Selects wetlands to full fill sampling requirements.   

#Ouput Scripts:   
Wet_04_output_BCWF.R	Outputs an excell table containing: 1) a score card for meeting sample requirements of past samples; 2) updated score card with suggested new samples; 3) wetland details for each proposed sample. Also produced are shape and kml files of the sampling wetlands.

### Project Status

The set of R WESP scripts are continually being modified and improved, including adding new study areas as sampling is initiated.

### Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an [issue](https://github.com/BCWF-Wetlands/WESP_data_prep/issues/).

### How to Contribute

If you would like to contribute, please see our [CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

### License

```
Copyright 2022 Province of British Columbia

Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
```
---
