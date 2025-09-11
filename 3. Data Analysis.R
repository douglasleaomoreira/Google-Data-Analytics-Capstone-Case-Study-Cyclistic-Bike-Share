#=====================================
# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================
# Descriptive analysis on ride_length (all figures in seconds)
mean(all_trips_v2$ride_length) #straight average (total ride length / rides)
median(all_trips_v2$ride_length) 
#midpoint number in the ascending array of ride lengths
max(all_trips_v2$ride_length) #longest ride
min(all_trips_v2$ride_length) #shortest ride

# You can condense the four lines above to one line using summary() on the 
# specific attribute
summary(all_trips_v2$ride_length)

# Compare members and casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

# See the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + 
            all_trips_v2$day_of_week, FUN = mean)

# Notice that the days of the week are out of order. Let's fix that.
all_trips_v2$day_of_week <- 
  ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", 
                                             "Wednesday", "Thursday", "Friday", 
                                             "Saturday"))

# Now, let's run the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + 
            all_trips_v2$day_of_week, FUN = mean)

# analyze ridership data by type and weekday
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  
  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							
            #calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		
  # calculates the average duration
  arrange(member_casual, weekday)								# sorts

# Let's visualize the number of rides by rider type
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# Let's create a visualization for average duration
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

# Convert Date and ride length format
# Load lubridate package
library(lubridate)

# Ensure datetime format is parsed correctly
all_trips$started_at <- as.POSIXct(all_trips$started_at, 
                                   format = "%d/%m/%Y %H:%M")
all_trips$ended_at   <- as.POSIXct(all_trips$ended_at,   
                                   format = "%d/%m/%Y %H:%M")

# Extract components from started_at
all_trips$date         <- as.Date(all_trips$started_at)
all_trips$year         <- format(all_trips$date, "%Y")
all_trips$month        <- format(all_trips$date, "%m")
all_trips$day          <- format(all_trips$date, "%d")
all_trips$day_of_week  <- format(all_trips$date, "%A")

# Compute ride length in minutes
all_trips$ride_length <- 
  as.numeric(difftime(all_trips$ended_at, all_trips$started_at, units = "mins"))

# Remove NA or negative ride lengths
all_trips_v2 <- all_trips %>%
  filter(!is.na(ride_length) & ride_length >= 0 & start_station_name != "HQ QR")

# Confirm structure
str(all_trips_v2)