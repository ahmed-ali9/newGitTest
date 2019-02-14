print("hello git world")
library(dplyr)
library(hflights)
data(hflights) #loads up the data into the global enviornment
head(hflights, n = 5) # n corresponds to the number
flights <- tbl_df(hflights) #converts the DF into a tbl, which has nicer printing qualities
flights

# 1st Verb: **FILTER* it filters by rows -----------------------------------------------------------

#base r : View all flights that are on January first
flights[flights$DayofMonth == 1 & flights$Month == 1 , ] # gets all the rows corresponding to Jan 1st
flights %>% filter(DayofMonth == 1, Month == 1) #dplyr way
#Very important note here, dplyr discards row names when we apply ANY verb
#or condition using dplyr
flights %>% filter(UniqueCarrier == "AA" | UniqueCarrier == "UA")
#Or you can use %in%
flights %>% filter(UniqueCarrier %in% c("AA", "UA"))

# 2nd Verb: **SELECT** it selects columns -------------------------------------------------------
flights %>% select(Year, Month, DayofMonth)
#you can also use the functions matches, starts_with, ends_with, and contains INSIDE the select()
#example:
flights %>% select(Year:Month, ends_with("Num"), contains("Day"))

# 3rd Verb: **ARRANGE** arranges rows-----------------------------------------------------------
flights %>% 
  select(UniqueCarrier, DepDelay) %>%  
  arrange(desc(DepDelay)) #notice it's ascending by default

# 4th Verb: **MUTATE** adds variables -----------------------------------------------------------
flights %>%
  mutate(Speed = Distance / AirTime * 60) #notice that it only prints out the output (doesn't adjust
#flights)


# Summarise: Reduce Variables to Value -------------------------------------------------------------
# USeful for data that has been grouped 
# group_by: Creates the groups
# summarise: uses the provided aggregation function to summarise each group
flights %>% 
  group_by(Dest) %>%
  summarise(avg_delay = mean(ArrDelay, na.rm = TRUE)) #note that Dest is doesn't need to be a factor
# summarise_each: Apply the same summary function to multiple columns at once
# mutate_each : also same
# for each carrier, calc. the % of flights cancelled or diverted
# whenever u see "for each" then you probably have to use group_by at somepoint
flights %>%
  group_by(UniqueCarrier) %>% 
  summarise_each(funs(mean), Cancelled, Diverted)
#funs define which function you're gonna use, then you list out the columns that you want this function
#to be applied to

#for each carrier, calculate the minimum and the maximum arrival and departure delays.

flights %>% 
  group_by(UniqueCarrier) %>% 
  summarise_each(funs(max(. , na.rm = TRUE), min(. , na.rm = TRUE)), matches("Delay"))
#remember that you input the function that u want to use inside funs() THEN you input the columns
#that the function inside funs() apply to
#I'm not sure why did we use (.) here, apparently, it's just a plceholder for the data that i put in

# n() counts the number of rows in a group
# n_distinct(vector) counts the number of unique items in said vector
#Example:
# for each day of the year, count the total number of flights and sort in descending order

flights %>% 
  group_by(Month, DayofMonth) %>% 
  summarise(number_of_flights = n()) %>%
  arrange(desc(number_of_flights))
#rewrite more simply by the tally function 

flights %>% 
  group_by(Month, DayofMonth) %>%  #note the two grouping variables capability
  tally( sort = TRUE) # sort = TRUE, sorts in descending order

#for each destination, count the total number of flights and the number of distinct planes that flew
#there 
