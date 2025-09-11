# 4. Data Export.R

#=================================================
# STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
#=================================================
# Create a csv file that we will visualize in Excel, Tableau, or my presentation 
# software
# N.B.: This file location is for a Mac. If you are working on a PC, change the 
# file location accordingly (most likely "C:\Users\YOUR_USERNAME\Desktop\...") 
# to export the data. You can read more here: 
# https://datatofish.com/export-dataframe-to-csv-in-r/
counts <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + 
                      all_trips_v2$day_of_week, FUN = mean)
write.csv(counts, file = 'avg_ride_length.csv')

# Check data details before export
unique(all_trips_v2$year)

length(unique(all_trips_v2$year))

table(all_trips_v2$year)

sort(table(all_trips_v2$year))

# Assuming started_at is POSIXct

# Extract year, month, day as integers
all_trips_v2$year <- year(all_trips_v2$started_at)
all_trips_v2$month <- month(all_trips_v2$started_at)
all_trips_v2$day <- day(all_trips_v2$started_at)

# Extract just the date (without time)
all_trips_v2$date <- as.Date(all_trips_v2$started_at)

# Check result
head(all_trips_v2[, c("started_at", "date", "year", "month", "day")])

str(all_trips_v2)

# Export all trips dataframe

write.csv(all_trips_v2, file = 'all_trips_v3.csv')


