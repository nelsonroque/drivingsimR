# drivingsimR
 Automated data aggregation routines for driving simulators used in research (e.g., DriveSafety).

## Tutorial

### (1) Install package
`devtools::install_github("nelsonroque/drivingsimR")`

### (2) Load your data, e.g.,
`driving_df = read_csv('filename.csv')`

### (3) Calculate session statistics
`general_session_stats(driving_df, group_var=c(participant_id, session_date), lag_n = 10, sim="drivesafety", fps_assumption=NA)`

### (4) View the result table!
`View(general_session_stats)`
