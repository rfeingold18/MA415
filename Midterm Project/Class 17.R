# Midterm Project 
# 
# OSHA DATA for Massachusetts- 2006 Occupational Safety and Health Inspection 
# Organization for investigative reporting 
#
# DBF- database files
# use foreign library 

# DO analysis to find: Dangerous Places to Work- have violation, accidents, are in dangerous occupations 


# to read file:
library(foreign)
a <- read.dbf("accid.dbf")
head(a)

#anonymized, so can't see sex or name

# Accidents (ACCID.DBF): 
# Names of those injured
# identifies the task that was being performed when the accident occurred
# indicates whether a hazardous substance contributed to the accident 
# lists which body parts were injured
# indicates the degree of  the injury -- for example, whether it was fatal.

aFac <- read.dbf("lookups/acc.dbf")
v <- read.dbf("viol.dbf")
# layout define variables
# lookouts 
# OSHA get perspective and context


# we will want to put all the tables into one big data frame
# we will need joins 

###################
# Accounts Payable Accounts 
library(dplyr)
library(lubridate)

set.seed(17)

ID <- 1:10
Name <- c("Bob", "Jane", "Ramesh", "Sijia", "Bo", "Pierre", "Margaret", "Bruce", "Nanci", "Sean" )
Age <- sample(x = 25:40, size = 10, replace = TRUE)
Address <- c("Seattle", "LA", "Islamabad", "Xiamen", "Shanghai", "Montreal", "Mousehole", "Sydney", "St. Lunair", "Cork")
APbalance <- sample(x= 200:2000, size=10, replace=FALSE)

AP <- data.frame(ID,Name,Age,Address,APbalance) # This is the Customers table
AP

# Order Table 
OID <- c(102, 100, 101, 103)
d <- sample(3:10, size=4, replace = FALSE)

# origin is the base state, and got randome numbers, which are in d 
Date <- as.Date(d, origin="2017-01-01")
ID <- c(3,3,2,4) # use ID's of customers in database
OrderAmt <- c(3000, 1200, 1300, 2500)

Orders <- data.frame(OID, Date, ID, OrderAmt)
Orders # a data frame

# JOINING DATA FRAMES
# LIST TABLES WHERE ID IS IN BOTH TABLES- order of columns is reset by the order of the function command

inner_join(AP, Orders, by = "ID")
# AP first, Orders second, only show rows where ID's occur in both tables
# Inner join returns rows when there is a match in both tables
# do the opposite
inner_join(Orders, AP, by = "ID")
########################################################

left_join(AP, Orders, by = "ID")

# Left join returns all the rows from the left table (AP)
# even if there are no matches in the right table
# show extra data, will fill in with NA's

left_join(Orders, AP, by = "ID")
# reverses it, should obviously be less rows, actually equivalent to inner joint
#######################################################

right_join(Orders, AP, by = "ID")

## Right join returns all the rows from the right table
## even if there are no matches in the left table, fills in the rest with NA's

right_join(AP, Orders, by = "ID")

########################################################

full_join(Orders, AP, by = "ID")

## full joint retains all values, all rows, regardless of order

full_join(AP, Orders, by = "ID")

####################################################

semi_join(AP, Orders, by ="ID")

## rows in AP that have a match in Orders
# do same, only have columns from AP but include rows that were in both 
# don't have 4 rows, only 3 people palces order

semi_join(Orders, AP, by ="ID")

## rows in Orders that have a match in AP

####################################################
library(foreign)

a <- read.dbf("accid.dbf")
# look at ACC> lookup code, see how it is handled 
# in occupation codes 
v <- read.dbf("viol.dbf")
# has repeat, serious, and willfull offenders HA 
# fat/cat 
# some data has to do with NICAR- 
# most OSHA violations handles admin., some taken to court, any taken to supreme court? 
lookAcc <- read.dbf("lookups/acc.dbf")

# want to be able to give data from someone to analyze (they should be able to lok at companies or violation or accidents) and we can present it
# will care about accidents and violation, might not care about other stuff

o <- read.dbf("osha.dbf")
# we have owners, company names, when they opened or clsoed, whether its a union shop or not, penalties and how much, site zip and cities
# all states should be MA, already cleaned for us? 
# use lubridate 
# OSHA is a summary- 
# need to find a file we build on top of, looking for something that has to do w dangerous places to work, can be categories
# either construct it and extract all names of companies OR use summary from OSHA
# NAICS- has classification codes- good way to analyze work, if all comapnies have same code, use that as a way to organize analysis, NEED A STANDARD WAY TO ORGANIZE 