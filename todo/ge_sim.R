#' drivingsimR: Automating the boring stuff, so you can calculate and later visualize what you care about.

#' @name general_session_stats
#' @import tidyverse
#' @keywords driving, session summary, person summary
#' @export
general_session_stats <- function(.data, group_var, lag_n = 10, sim="drivesafety", fps_assumption=NA) {
  if(!fps_assumption || is.na(fps_assumption)) {
    stop("Please enter parameter fps_assumption with value greater than or equal to 10 (as integer).")
  } else {

    if(sim != "drivesafety"){
      stop("Sorry, at this time, the only supported driving simulator is DriveSafety. Please email nelson.roque@ucf.edu if interested in seeing support for another driving simulator (e.g., sharing sample raw data, codebooks).")
    }

    .data %>%
      # pre-process raw data before running feature calculations -----

      # recode oddities -----
      mutate(LanePos_recode = as.numeric(replace(LanePos, LanePos == "-", NA))) %>%

      # calculate change scores ----
      mutate(velocity_change = Velocity - lag(Velocity, lag_n)) %>%
      mutate(brake_change = Brake - lag(Brake, lag_n)) %>%

      # group output by specified grouping variables -----
      group_by(across({{group_var}})) %>%
      summarise(min_session_time = min(Time, na.rm=T),
                max_session_time = max(Time, na.rm=T),

                # vehicle location -----
                min_vehicle_x = min(SubjectX, na.rm=T),
                max_vehicle_x = max(SubjectX, na.rm=T),

                min_vehicle_y = min(SubjectY, na.rm=T),
                max_vehicle_y = max(SubjectY, na.rm=T),

                # vehicle velocity ----- (get units from DS codebook)
                mean_velocity = mean(Velocity, na.rm=T),
                median_velocity = median(Velocity, na.rm=T),
                p10_velocity = quantile(Velocity, probs=0.1, na.rm=T),
                p30_velocity = quantile(Velocity, probs=0.3, na.rm=T),
                p70_velocity = quantile(Velocity, probs=0.7, na.rm=T),
                p90_velocity = quantile(Velocity, probs=0.9, na.rm=T),
                sd_velocity = sd(Velocity, na.rm=T),
                # sum_velocity_gte_1 = sum(Velocity > 0 & Velocity <= 1, na.rm=T),# <--- maybe some sum scores?

                # vehicle acceleration ----- (get units from DS codebook)
                mean_accel = mean(Accel, na.rm=T),
                median_accel = median(Accel, na.rm=T),
                p10_accel = quantile(Accel, probs=0.1, na.rm=T),
                p30_accel = quantile(Accel, probs=0.3, na.rm=T),
                p70_accel = quantile(Accel, probs=0.7, na.rm=T),
                p90_accel = quantile(Accel, probs=0.9, na.rm=T),
                sd_accel = sd(Accel, na.rm=T),

                # vehicle lane position ----- (get units from DS codebook)
                mean_lanepos = mean(LanePos_recode, na.rm=T),
                median_lanepos = median(LanePos_recode, na.rm=T),
                p10_lanepos = quantile(LanePos_recode, probs=0.1, na.rm=T),
                p30_lanepos = quantile(LanePos_recode, probs=0.3, na.rm=T),
                p70_lanepos = quantile(LanePos_recode, probs=0.7, na.rm=T),
                p90_lanepos = quantile(LanePos_recode, probs=0.9, na.rm=T),
                sd_lanepos = sd(LanePos_recode, na.rm=T),

                # vehicle steering angle ----- (get units from DS codebook)
                mean_steer = mean(Steer, na.rm=T),
                median_steer = median(Steer, na.rm=T),
                p10_steer = quantile(Steer, probs=0.1, na.rm=T),
                p30_steer = quantile(Steer, probs=0.3, na.rm=T),
                p70_steer = quantile(Steer, probs=0.7, na.rm=T),
                p90_steer = quantile(Steer, probs=0.9, na.rm=T),
                sd_steer = sd(Steer, na.rm=T),

                # vehicle lataccel ----- (get units from DS codebook)
                mean_lataccel = mean(LatAccel, na.rm=T),
                median_lataccel = median(LatAccel, na.rm=T),
                p10_lataccel = quantile(LatAccel, probs=0.1, na.rm=T),
                p30_lataccel = quantile(LatAccel, probs=0.3, na.rm=T),
                p70_lataccel = quantile(LatAccel, probs=0.7, na.rm=T),
                p90_lataccel = quantile(LatAccel, probs=0.9, na.rm=T),
                sd_lataccel = sd(LatAccel, na.rm=T),

                # vehicle brake ----- (get units from DS codebook)
                mean_brake = mean(Brake, na.rm=T),
                median_brake = median(Brake, na.rm=T),
                p10_brake = quantile(Brake, probs=0.1, na.rm=T),
                p30_brake = quantile(Brake, probs=0.3, na.rm=T),
                p70_brake = quantile(Brake, probs=0.7, na.rm=T),
                p90_brake = quantile(Brake, probs=0.9, na.rm=T),
                sd_brake = sd(Brake, na.rm=T),

                median_change_brake = median(brake_change, na.rm=T),
                median_change_velocity = median(velocity_change, na.rm=T),

                collision_events = paste0(unique(Collision))) %>%
      # create flags if certain critical data outliers exist -----
      mutate(flag_session_0_0_origin = ifelse(min_vehicle_x == 0 & min_vehicle_y == 0, T, F),
             flag_if_collision = ifelse(!is.na(collision_events), T, F)) %>%
      mutate(param_fps_assumption = fps_assumption)
  }
}
