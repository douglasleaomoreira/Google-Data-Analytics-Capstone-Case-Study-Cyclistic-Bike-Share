# 2. Data Cleaning.R

#======================================================
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================
# Inspect the new table that has been created
colnames(all_trips)  #List of column names
nrow(all_trips)  #How many rows are in data frame?
dim(all_trips)  #Dimensions of the data frame?
head(all_trips)  #See the first 6 rows of data frame.  Also tail(all_trips)
str(all_trips)  #See list of columns and data types (numeric, character, etc)
summary(all_trips)  #Statistical summary of data. Mainly for numerics

# There are a few problems we will need to fix:
# (1) In the "member_casual" column, there are two names for members ("member" 
# and "Subscriber") and two names for casual riders ("Customer" and "casual"). 
# We will need to consolidate that from four to two labels.
# (2) The data can only be aggregated at the ride-level, which is too granular. 
# We will want to add some additional columns of data -- such as day, month, 
# year -- that provide additional opportunities to aggregate the data.
# (3) We will want to add a calculated field for length of ride since the 2020Q1 
# data did not have the "tripduration" column. We will add "ride_length" to the 
# entire dataframe for consistency.
# (4) There are some rides where tripduration shows up as negative, including 
# several hundred rides where Divvy took bikes out of circulation for Quality 
# Control reasons. We will want to delete these rides.

# In the "member_casual" column, replace "Subscriber" with "member" and 
# "Customer" with "casual"
# Before 2020, Divvy used different labels for these two types of riders ... we 
# will want to make our dataframe consistent with their current nomenclature
# N.B.: "Level" is a special property of a column that is retained even if a 
# subset does not contain any values from a specific level
# Begin by seeing how many observations fall under each usertype
table(all_trips$member_casual)

# Reassign to the desired values (we will go with the current 2020 labels)
all_trips <-  all_trips %>% 
  mutate(member_casual = recode(member_casual
                                ,"Subscriber" = "member"
                                ,"Customer" = "casual"))

# Check to make sure the proper number of observations were reassigned
table(all_trips$member_casual)

# Add columns that list the date, month, day, and year of each ride
# This will allow us to aggregate ride data for each month, day, or year ... 
# before completing these operations we could only aggregate at the ride level
# https://www.statmethods.net/input/dates.html more on date formats in R found 
# at that link
all_trips$date <- as.Date(all_trips$started_at) #The default format is 
# yyyy-mm-dd
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

# Add a "ride_length" calculation to all_trips (in seconds)
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/difftime.html
all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)

# Inspect the structure of the columns
str(all_trips)

# Convert "ride_length" from Factor to numeric so we can run calculations on 
# the data
is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

# Check for duplicate and missing values in the all_trips DataFrame
# Show duplicated rows
all_trips[duplicated(all_trips), ]

# Count duplicated rows
sum(duplicated(all_trips))

# Total missing values
sum(is.na(all_trips))

# Missing values by column
colSums(is.na(all_trips))

# Show rows that contain any missing values
all_trips[!complete.cases(all_trips), ]

# Remove "bad" data
# The dataframe includes a few hundred entries when bikes were taken out of 
# docks and checked for quality by Divvy or ride_length was negative
# We will create a new version of the dataframe (v2) since data is being 
# removed
# https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-
# conditions-2/
all_trips_v2 <- all_trips[!(all_trips$start_station_name 
                            == "HQ QR" | all_trips$ride_length<0),]

# Check for duplicate and missing values in the all_trips_v2 DataFrame for 
# comparison
# Show duplicated rows
all_trips_v2[duplicated(all_trips_v2), ]

# Count duplicated rows
sum(duplicated(all_trips_v2))

# Total missing values
sum(is.na(all_trips_v2))

# Missing values by column
colSums(is.na(all_trips_v2))

# Show rows that contain any missing values

all_trips_v2[!complete.cases(all_trips_v2), ]
