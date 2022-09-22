library(readr)
library(tidyverse)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fyp_files = list.files(path="1st Year Project/output/", pattern=".txt", recursive=T, full.names = T)
all_files = fyp_files

a  = read_directory_driving(dirname, c("Baseline", "HighTraffice", "LowTraffic"))
b = drivestats(a)

agg_per_dirve = df_all %>%
  group_by(traffic_level, distraction_condition, bin) %>%
  summarise(mean_speed = mean(speed),
            sd_speed = mean(speed),
            mean_speed_f_lt_10000 = mean(speed[frame < 10000]),
            n = n())


files_bd = all_files[grepl("Baseline", all_files)]
files_ht_c = all_files[grepl("High_Traffic_Call", all_files)]
files_lt_c = all_files[grepl("Low_Traffic_Call", all_files)]
files_ht_t = all_files[grepl("High_Traffic_Text", all_files)]
files_lt_t = all_files[grepl("Low_Traffic_Text", all_files)]

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bd_df = lapply(files_bd, read_delim, delim = "\t", escape_double = FALSE,
       trim_ws = TRUE, skip = 206)

# read in all files ----
df_bd <- read_delim(files_bd,
                    delim = "\t", escape_double = FALSE,
                    trim_ws = TRUE, skip = 206)
# %>%
#   mutate(drive_type = "baseline") %>%
#   mutate(traffic_level = "baseline") %>%
#   mutate(distraction_condition = "baseline")

df_ht_call <- read_delim(files_ht_c, 
                         delim = "\t", escape_double = FALSE, 
                         trim_ws = TRUE, skip = 120) %>%
  mutate(drive_type = "experimental") %>%
  mutate(traffic_level = "high") %>%
  mutate(distraction_condition = "call")

df_lt_call <- read_delim(files_lt_c, 
                         delim = "\t", escape_double = FALSE, 
                         trim_ws = TRUE, skip = 91) %>%
  mutate(drive_type = "experimental") %>%
  mutate(traffic_level = "low") %>%
  mutate(distraction_condition = "call")

df_ht_text <- read_delim(files_ht_t,
                         delim = "\t", escape_double = FALSE, 
                         trim_ws = TRUE, skip = 120) %>%
  mutate(drive_type = "experimental") %>%
  mutate(traffic_level = "high") %>%
  mutate(distraction_condition = "text")


df_lt_text <- read_delim(files_lt_t, 
                         delim = "\t", escape_double = FALSE, 
                         trim_ws = TRUE, skip = 91)  %>%
  mutate(drive_type = "experimental") %>%
  mutate(traffic_level = "low") %>%
  mutate(distraction_condition = "text")

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# merge all datasets together ----
df_all <- bind_rows(df_ht_call, df_ht_text,
                    df_lt_call, df_lt_text)
