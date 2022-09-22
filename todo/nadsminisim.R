# >>>>>>>>>>>>>>>>>>>>>>>>>>>
# Code by Nelson Roque
# Florida State University
# >>>>>>>>>>>>>>>>>>>>>>>>>>>
#rm(list=ls())

DEBUG_CODE <- 0

# for script timing
s1 <- proc.time()
START_TIME <- s1[3]

library(R.matlab)
library(ggplot2)

# set directory
base.path <- '/Users/nelsonroque/Documents/Programming/R/'
project.name <- 'WW_CM_CP/'
project.path <- paste(base.path, project.name, sep="")
data.path <- paste(project.path, "data/exp/", sep="")
output.path <- paste(project.path,"output/", sep="")

# get list of files
file.list <- list.files(data.path) # set to data/exp/ first

if(DEBUG_CODE == 1){
  file.list <- file.list[1]
}

master.df <- data.frame()

for (file in file.list) {
  temp.df <- readMat(paste(data.path,"/",file,sep=""))
  
  # view data elements in .mat
  exp_name <- toString(temp.df$daqInfo[1])
  exp_split <- strsplit(exp_name,"_")
  project_name <- exp_split[[1]][1]
  project_center <- exp_split[[1]][2]
  exp_version <- paste(exp_split[[1]][3],exp_split[[1]][4],sep="_")
  run_date_time <- temp.df$daqInfo[6]
  subject <- temp.df$daqInfo[8]

  # for debugging
  print("======START========")
  print(run_date_time)
  print(exp_version)
  print("=======END========")

  # get all frame level data
  #Follow.Info <- temp.df$elemData[1]
  Chassis.Position <- temp.df$elemData[1] # 3 col
  Chassis.X <- Chassis.Position[[1]][,1]
  Chassis.Y <- Chassis.Position[[1]][,2]
  Collision.Count <- unlist(temp.df$elemData[2])
  if(length(Collision.Count) < length(Chassis.X)){
    Collision.Count <- c(0,Collision.Count)
  }
  
  Steering.Angle <- temp.df$elemData[3]
  Frames <- temp.df$elemData[4]
  Log.Streams <- temp.df$elemData[5]
  Lane.Deviation <- temp.df$elemData[6]
  Veh.Speed <- temp.df$elemData[7]
  Brake.Force <- temp.df$elemData[8]
  
  # extract seperate log streams
  All.LS <- Log.Streams[[1]]
  Log.Stream.1 <- All.LS[,1]
  Log.Stream.2 <- All.LS[,2]
  Log.Stream.3 <- All.LS[,3]
  Log.Stream.4 <- All.LS[,4]
  Log.Stream.5 <- All.LS[,5]
  
  # extract lane deviation
  All.LD <- Lane.Deviation[[1]]
  LD.1 <- Lane.Deviation[[1]][,1] # -2 - 1
  LD.2 <- Lane.Deviation[[1]][,2] # -6 - +6
  LD.3 <- Lane.Deviation[[1]][,3] # 0-12
  LD.4 <- Lane.Deviation[[1]][,4] # 0-9
  
  # get dimension information
  Log.Dims <- dim(Log.Streams[[1]])
  Total.Frames <- nrow(Frames)

  # create participant df
  export.df <- data.frame(subject,
                          project_name,project_center,exp_version,
                          run_date_time,Frames,
                          Log.Stream.1,Log.Stream.2,Log.Stream.3,Log.Stream.4,Log.Stream.5,
                          Chassis.X,Chassis.Y,
                          Collision.Count,Steering.Angle,
                          Veh.Speed,Brake.Force,
                          LD.1,LD.2,LD.3,LD.4)
  
  colnames(export.df) <- c('Subject','Project','Project_Source','Experiment_Version',
                           'Run_Time','Frames',
                           'Log_Stream1','Log_Stream2','Log_Stream3','Log_Stream4','Log_Stream5',
                           'Chassis.X','Chassis.Y',
                           'Collision.Count',"Steering_Angle",
                           'Speed','Brake.Force',
                           'LD.1','LD.2','LD.3','LD.4')
  
  master.df <- rbind(master.df,export.df)
}

if(length(unique(master.df$Subject)) == length(file.list)) {
  print("Saving to file...")
  write.table(master.df, paste(output.path, "WW_CM_CP_FrameLevelData_AllParticipants.txt",sep=""), sep="\t", row.names=FALSE)
} else {
  print("not all subjects were successfully processed.")
}

# for script timing
e1 <- proc.time()
END_TIME <- e1[3]

SCRIPT_RT <- (END_TIME - START_TIME)
print(paste("SCRIPT COMPLETED IN: ",SCRIPT_RT," seconds",sep=""))