# dplyr 
# pacakage for data manipulation and analysis

head(airquality)
library(datasets)
library(dplyr)

# filter
# returns all the rows that satisfy a specific condition

filter(.data = airquality, Temp > 70)
filter(.data = airquality, Temp > 80 & Month > 5)


# mutate 
# add new variables to the data

mutate(.data = airquality, TempInC = (Temp - 32) * 5/9)
# adds a new column that displays temp in Celsius

# summarize
# summarizes multiple vales into a single value

summarise(.data = airquality, mean(Temp, na.rm= TRUE))
# calculates mean and removes all NA values

# group_by
# groups data by one or more variables

summarise(group_by(airquality, Month), mean(Temp, na.rm = TRUE))
# calculates mean temperature in each month

# sample
# selects random rows from a table

sample_n(airquality, size = 10)
sample_frac(airquality, size = 0.1)
# selects 10 random rows
# selects 10% of the original rows

# count
# tallies observations based on a group 

count(airquality, Month)

# arrange
# arranges row by variables, descending or ascending

arrange(airquality, desc(Month), Day)

# pipe 
# %>% used to chain code together when performing multiple operations, save output at each intermediate step 

filteredData <-  filter(airquality, Month !=5)
groupedData <-group_by(filteredData, Month)
summarise(groupedData, mean(Temp, na.rm = TRUE))

# remove all data corresponding to Month =5, group data by Month, then find mean Temp of each month
# with piping v

airquality %>%
  filter(Month != 5) %>%
  group_by(Month) %>%
  summarise(mean(Temp, na.rm = TRUE))


# Other Dyplr Functions

# select

library(dplyr)


iris <- tbl_df(iris) # so it prints a little nicer
head(iris)
?iris

iris

tail(iris)

select(iris, starts_with("Petal")) # select columns with the word 'Petal' in them

select(iris, ends_with("Width"))
select(iris, contains("etal"))
select(iris, matches(".t."))
select(iris, Petal.Length, Petal.Width)
vars <- c("Petal.Length", "Petal.Width")
select(iris, one_of(vars))

view(iris)
# look at data frame as a table
