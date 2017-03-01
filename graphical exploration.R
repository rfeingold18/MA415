# process
# 1. find data and read it
# 2. raw data - type check and clean
# 3. technically correct data 
# 4. restructure and missing
# 5. tidy data
# need provenance of data for analysis and presentation 

library(ggplot2)
library(dplyr)

# use CO2 from the built in data- cold tolerance of grass species
# To get documentation on the dataset: ?CO2 84 rows, 5 columns 
# to see how much data you have: dim(CO2) 
# head(CO2)- plant, type, treatment, conc, uptake

p <- ggplot(data=CO2, aes(x=conc,y=uptake)) #primary step 
# start playing around with plots

p + geom_point() 
p + geom_point(aes(color=Type))
p + geom_point(aes(color=Type, shape=Treatment),size=3)
p + geom_point() + facet_grid(Type ~ Treatment) #makes 4 graphs of different combos of type and treatment
p + geom_point(aes(color=Plant)) + facet_grid(Type ~ Treatment) #uses colors, but they refer to individual plant, can't see anything
p + geom_point(aes(color=Treatment)) + facet_grid(Plant~Type)
p + geom_label(aes(label=Plant)) # has labels
p + geom_label(aes(label=Plant, color=Treatment)) + 
  facet_grid(Type~.)

#################
# chickwts-measure effectiveness of feed supplements on growth rate of chickens

head(chickwts)
?chickwts
dim(chickwts) # 71 3 71 observations 2 variables
ggplot(chickwts, aes(feed)) + geom_bar()

###################
# different ways to find data
# data sets: 
#  a handbook of small data sets google books 

# national agricultural statisytical services  
#   survey>crops>fieldcrops>corn>progress> grab all variables> by state >years 2010-16
#   get data base, save as .csv 

# corn dog file
# use dplyr and magrittr for cleaning  

library(dplyr)
library(magrittr)

corn <- read.csv("corn.csv", header = TRUE, stringsAsFactors = FALSE)
sum(is.na(corn$week.Ending)) #should get 2985
corn <- select(corn, -matches("Week.Ending")) #drops one of the variables
sum(is.na(corn$Ag.District))

# does whatever it had to do and rewrites it as corn
corn %<>% select(-matches("Week.Ending")) #drops by 2 variables

# want to save this whole thing, don't want to have to do this everytime
save(file = "corndob.sav", list = "corn")

# load it and assign it a new name

cd <- load("corndog.sav")

# brings in corn and makes all changes
# 
# 
# data on the internet

# ndbc.noaa.gov shows buoys that collect weather and sea condition data, such as period between waves 
# 044013 buoy in boston 




##  let's see ...
##  We want to read the 2016 data from buoy 51208 
##
##  for comparison purposes I have a picture of it

##  
##  try

a <- read.table("http://www.ndbc.noaa.gov/view_text_file.php?filename=51208h2016.txt.gz&dir=data/historical/stdmet/",header = TRUE)
head(a)

##  No header, missing first row

b <- read.table("http://www.ndbc.noaa.gov/view_text_file.php?filename=51208h2016.txt.gz&dir=data/historical/stdmet/",header = FALSE)
head(b)


## better. no headers, but it read the first row

## so ...

fyl <- "http://www.ndbc.noaa.gov/view_text_file.php?filename=51208h2016.txt.gz&dir=data/historical/stdmet/"


# read the column names
header <- scan(fyl,nlines=1,what=character())

# read the data
buoy <- read.table(fyl,skip=2,header=FALSE)

# re-attach the column names
colnames(buoy)<-header
head(buoy)

