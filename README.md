# drivingsimR
 Automated data aggregation routines for driving simulators used in research (e.g., DriveSafety).

## Tutorial

### (1) Install package
`devtools::install_github("nelsonroque/drivingsimR")`

#### Load packages
`library(drivingsimR)`
`library(tidyverse)`

### (2) Load your data, e.g.,
`driving_df = read_csv('filename.csv')`

### (3) Calculate session statistics
`session_stats <- general_session_stats(driving_df, group_var=c(SubjectName), lag_n = 10, sim="drivesafety", fps_assumption=60)`

### (4) View the result table!
`View(session_stats)`


#### Sorry, at this time, the only supported driving simulator is DriveSafety. 

Please email nelson.roque@ucf.edu if interested in seeing support for another driving simulator (e.g., sharing sample raw data, codebooks).
