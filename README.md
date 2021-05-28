### Wetland Ecosystem Services Protocol (WESP) Sample Draw

<!-- Add a project state badge
See https://github.com/BCDevExchange/Our-Project-Docs/blob/master/discussion/projectstates.md
If you have bcgovr installed and you use RStudio, click the 'Insert BCDevex Badge' Addin. -->

\# WESP_Sample_Draw

    Takes a csv or excel file of wetlands, where each row is a wetland with attributes describing its flow characteristics, type of adjacent land cover, disturbance, and other sample selection criteria. A report card is generated identifying how many wetlands are in each attribute category. A sample draw can be generated based on the sampling requirement described by the wetland's attributes.

\#\#\# Usage

There are five core scripts that are required for the analysis. A
run_all.R script passes files, parameters, and sampling requirements.

-   run_all.R - 2 example are included - ESI and BCWF
-   Wet_02_clean_data.R
-   Wet_03.1_analysis_ReportCard_1.R - generates an initial report card
-   Wet_03.2_analysis_sampleRequirements.R - runs the sample draw
-   Wet_04_output.R

#### Example

``` r
## basic example code
```

### Project Status

[![img](https://img.shields.io/badge/Lifecycle-Maturing-007EC6)](https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md)

### Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an
[issue](https://github.com/bcgov/WESP_Sample_Draw/issues/).

### How to Contribute

If you would like to contribute, please see our
[CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.

### License

    Copyright 2021 Province of British Columbia
    Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
    Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and limitations under the License.

------------------------------------------------------------------------

*This project was created using the
[bcgovr](https://github.com/bcgov/bcgovr) package.*
[![img](https://img.shields.io/badge/Lifecycle-Maturing-007EC6)](https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md)

This repository is maintained by
[ENVEcosystems](https://github.com/orgs/bcgov/teams/envecosystems/members).
