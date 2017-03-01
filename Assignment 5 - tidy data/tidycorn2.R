library(stringr)
library(tidyr)
library(diplyr)
library(magrittr)
library(data.table)
library(ggplot2)
library(lubridate)
library(plyr)
library(utils)

# TIDY DATA 
# Steps taken to tidy data set:
# 1. Read in .csv file
# 2. Remove columns with all NA values
# 3. Remove columns with all values being the same 
# 4. Change Period (which is month) to a number and State 
# 5. Make values of the variables factors- special steps for Value and Data.Item columns

# read in corn.csv, need to set working directory
setwd("~/MA415")
corn = read.csv2("corn.csv",sep = ",",stringsAsFactors = F)

colnames(corn) 
head(corn)

# check each variable(column) and if it is all NAs, can drop the column
# doing it by hand 
# indicate which columns have all NA's 
NAcols <- c(4, 8:13, 15, 21)
tidycorn <- corn[,-NAcols]

#if there is too much NA, check them one by one is time consuming and tiring, a loop is recommended
indi = rep(0,ncol(corn))
indi
for(i in 1: ncol(corn)){indi[i] = sum(!is.na(corn[,i]))}
which(indi==0)
#[1]  4  8  9 10 11 12 13 15 21
tidycorn = corn[,-c(which(indi==0))]
rm(indi,corn)
help(rm)
# we removed 9 variables

# if the value in column(variable) doesn't change at all, then drop column
# use table function on 12 remaining columns (variables),  which counts frequency of different factors in each column
table(tidycorn$Program) # drop
table(tidycorn$Year) # keep
table(tidycorn$Period) # keep
table(tidycorn$Geo.Level)# drop
table(tidycorn$State) # keep
table(tidycorn$State.ANSI) # keep
table(tidycorn$watershed_code) # drop
table(tidycorn$Commodity) # drop
table(tidycorn$Data.Item) # keep
table(tidycorn$Domain) # drop
table(tidycorn$Domain.Category) # drop
table(tidycorn$Value) # keep

# take the stable info of this dataset just in case
Info = tidycorn[,c("Domain","Domain.Category","Commodity","watershed_code","Program","Geo.Level")][1,]
Info  
# Domain Domain.Category Commodity watershed_code Program Geo.Level
# 1  TOTAL   NOT SPECIFIED      CORN              0  SURVEY     STATE

# Drop them 
# can use a function 
dr = function(name){
  return(which(colnames(tidycorn)==name))}
  tidycorn = tidycorn[,-c(dr("Domain"),
                        dr("Domain.Category"),
                        dr("Commodity"),
                        dr("watershed_code"),
                        dr("Program"),
                        dr("Geo.Level"))]
rm(i,dr)

# can do it by hand, as before 
Stablecols <- c(1, 4, 7, 8, 10, 11)
tidycorn <- tidycorn[,-Stablecols]

# change: (A) Period (month) into a number and (B) State into lower case
# (A)
tidycorn$State = tolower(tidycorn$State)
# (B)
month.abb.c = toupper(month.abb) ##extract Month name from build-in variable
for(i in 1:length(month.abb.c)){#check and substitude the month by number
  tidycorn$Period = gsub(pattern = month.abb.c[i],replacement = i,x = tidycorn$Period)
}

# table(tidycorn$Period)#12 thru 2 #9 thru 11 indicate time periods
# gsub function: input a variable string (THRU), sets a pattern, and gives a replacement (~) SHOULD CHANGE PERIOD COLUMN
tidycorn$Period = gsub(pattern = "THRU",replacement = "~",x = tidycorn$Period) #replace the "THRU"
#table(tidycorn$Period) 

# make values of the variables factors ok now we need to setup the variable format: factors numbers chars, etc.
# can use "stringsAsFactors = T" when reading in data to set all string variables to factors
# can also use factor() function
tidycorn$Year <- factor(tidycorn$Year)
levels(tidycorn$Year)
# for period, can specify the levels of the factor
tidycorn$Period <- factor(tidycorn$Period,levels = c("1","2","3","4","5","6","7","8","9","10","11","12","9 ~ 11","12 ~ 2"))
levels(tidycorn$Period)

tidycorn$State <- factor(tidycorn$State)
levels(tidycorn$State)

tidycorn$State.ANSI <- factor(tidycorn$State.ANSI)
levels(tidycorn$State.ANSI)

# Value variable is different, it's a numerical value
warning(as.numeric(tidycorn$Value)) # NA's introduced by coercion
#find why this happens
which(is.na(as.numeric(tidycorn$Value)))#find which row turned to NA
tidycorn$Value[which(is.na(as.numeric(tidycorn$Value)))] #is the comma
#eliminate the comma and switch type to numeric
tidycorn$Value = gsub(pattern = ",",replacement = "",x = tidycorn$Value)
tidycorn$Value = as.numeric(tidycorn$Value)

# need to eliminate redundancies in the Data.Item column
table(tidycorn$Data.Item)
# CORN,          GRAIN - PRICE RECEIVED, MEASURED IN $ / BU    
# CORN,          GRAIN - SALES,          MEASURED IN PCT OF MKTG YEAR
# CORN, ON FARM, GRAIN - DISAPPEARANCE,  MEASURED IN BU 

# there are three options for this variable , first turn into strings
tidycorn$Data.Item = as.character(tidycorn$Data.Item)
# seperates data.item column: into 4 columns names "Data Item" +  '1:4' so get Data.Item1, Data.Item2,..cont.
#seperated by commas, all of which is seperated by ",", removing the input column (orginial data.item) from tidycorn
tidycorn %<>% separate(Data.Item, into = paste("Data.Item",1:4,sep = ""),sep = ", ",remove = TRUE)
#Turns:
#CORN,          GRAIN - PRICE RECEIVED, MEASURED IN $ / BU    
#Into:
#| CORN | GRAIN - PRICE RECEIVED | MEASURED IN $ / BU | NA
table(tidycorn$Data.Item1) # can drop data.item1 column, all same values (stable column like before)
tidycorn$Data.Item1 = NULL
sum(!is.na(tidycorn$Data.Item4)) #can not drop! not all of values are NA

# create a table of just data that was Data.Item2 == ON FARM GRAIN - DISAPPEARANCE MEASURED IN BU
table3 = subset(tidycorn,subset = Data.Item2 == "ON FARM")
# create tidycorn 2, which removes all the above observations
tidycorn = tidycorn[-as.integer(rownames(table3)),]
colnames(table3)
# want to change column names of table3 to:
##Data.Item3 ---> Data.Item2
##Data.Item4 ---> Data.Item3
##Data.Item2 ---> Data.Item4
colnames(table3) = c("Year","Period" ,"State" ,"State.ANSI","Data.Item4","Data.Item2","Data.Item3","Value" )
table3 = table3[,c("Year","Period","State","State.ANSI","Data.Item2","Data.Item3","Data.Item4","Value")]
table3$Value = gsub(pattern = ",",replacement = "",x = table3$Value)
table3$Value = as.numeric(table3$Value)
tidycorn = rbind(tidycorn,table3) # add rows from table3 to tidycorn 2
rm(table3) # removes table 3
# sperates column data.item2 into two columns data.item.sub1 and data.item.sub2 GRAIN SALES OR GRAIN PRICE RECEIVED turns into GRAIN- SALES or GRAIN- PRICES RECEIVES
tidycorn %<>% separate(Data.Item2, into = paste("Data.Item.sub",1:2,sep = ""),sep = " - ",remove = TRUE)
table(tidycorn$Data.Item.sub1)
tidycorn$Data.Item.sub1 = NULL  # GRAINS is not a stable column/variable, can drop it 

# need to save all this work!!!
save(file = "corndog.sav", list = "tidycorn")
save(tidycorn,file = "tidycorn.Rdata")
rm(list = ls())

