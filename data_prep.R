library(dplyr)
library(leaflet)

stop_times <- read.delim("pkpic/stop_times.txt", sep = ",")
stops <- read.delim("pkpic/stops.txt", sep = ",")
trips <- read.delim("pkpic/trips.txt", sep = ",")

trips <- trips %>%  
  select(trip_id, trip_short_name) 

stop_times <- stop_times %>% 
  mutate(departure_time = 
           case_when(substr(departure_time, start = 1, stop = 2) == "24" ~ 
                       strptime(paste0("00", substr(departure_time, start = 3, 
                                                    stop = 8)), format = "%H:%M:%S"), 
                     .default = strptime(departure_time, format = "%H:%M:%S")),
          arrival_time = 
            case_when(substr(arrival_time, start = 1, stop = 2) == "24" ~ 
                        strptime(paste0("00", substr(arrival_time, start = 3, 
                                                     stop = 8)), format = "%H:%M:%S"), 
                      .default = strptime(arrival_time, format = "%H:%M:%S")))

stop_times <- merge(x = stop_times, y = stops %>% select(-stop_IBNR), 
                    all.x = TRUE, all.y = FALSE, by = "stop_id")

stop_times <- merge(x = stop_times, y = trips, all.x = TRUE, all.y = FALSE, 
                    by = "trip_id")

for (stop in unique(stops$stop_name)) {
  file <- paste0("data/", gsub(" ", "_", stop))
  
  dep <- stop_times %>% 
    filter(stop_name == stop) %>% 
    select(trip_id, stop_sequence, departure_time) %>% 
    rename(at_req_station = departure_time, req_stop_seq = stop_sequence)
  
  req_stop_times <- merge(x = stop_times, y = dep, by = "trip_id", all.x = TRUE,
                          all.y = FALSE)
  
  req_stop_times <- req_stop_times %>% 
    mutate(time = case_when(stop_sequence > req_stop_seq & 
                              arrival_time >= at_req_station ~ 
                              as.numeric(difftime(arrival_time, at_req_station, 
                                                  units = "secs")),
                            stop_sequence > req_stop_seq & 
                              arrival_time < at_req_station ~
                              as.numeric(difftime(arrival_time, at_req_station, 
                                         units = "secs")) + 24*3600,
                            stop_sequence == req_stop_seq ~ 0,
                            .default = NA))
  
  req_stop_times <- req_stop_times %>% 
    filter(!is.na(time)) %>%
    group_by(stop_name, trip_short_name) %>% 
    reframe(min_time = min(time), mean_time = mean(time), stop_lon = stop_lon, 
            stop_lat = stop_lat) %>% 
    unique()
   
  saveRDS(req_stop_times, file)
  
  rm(req_stop_times)
}

