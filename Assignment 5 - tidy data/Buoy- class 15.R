##  let's see ...
##  We want to read the 2016 data from buoy 51208 for comparison purposes I have a picture of it
## The buoy is time series data- very simple, many observations

# link: http://www.ndbc.noaa.gov/view_text_file.php?filename=51208h2016.txt.gz&dir=data/historical/stdmet/
# linear regression models: the Epsilons errors are ii.d examine them to see if they are normally distributed, if theres is constant variance, if mean = 0, and if its in fact i.i.d
# in time series we know that they are correlated observations in time (not independent) 
# want to see if time v ATM is sinsuoidal (seasonal variation)

a <- read.table("http://www.ndbc.noaa.gov/view_text_file.php?filename=51208h2016.txt.gz&dir=data/historical/stdmet/",header = TRUE)
head(a)
##  No header, missing first row
b <- read.table("http://www.ndbc.noaa.gov/view_text_file.php?filename=51208h2016.txt.gz&dir=data/historical/stdmet/",header = FALSE)
head(b)

# read table: allows you to skip some rows, change row and column names, etc. 
# first row is variable names, second row is units  

## better. no headers, but it read the first row
fyl <- "http://www.ndbc.noaa.gov/view_text_file.php?filename=51208h2016.txt.gz&dir=data/historical/stdmet/"
head(fyl)
# read the column names
header <- scan(fyl,nlines=1,what=character()) # can scan a number of lines, you can tell it what it's scanning
header
str(header)
# read the data
buoy <- read.table(fyl,skip=2,header=FALSE)

# re-attach the column names
colnames(buoy)<-header
head(buoy)

# Problems with this data set
# 1. number of variables change after 1999
# 2. some missing times 
# 3. there are NA rows in the file 


###

str1 = "http://www.ndbc.noaa.gov/view_text_file.php?filename="
str2 = ".txt.gz&dir=data/historical/stdmet/"
buoynum <- "44013"

# years to read since data layout was the same for these years
y1 <- 1984
y2 <- 1999

data <- NULL

# makes the url we want to hear
# paste0 puts them together without a space
# did as before 

while(y1<=y2){
  # make the file name
  fyl <- paste0(str1,buoynum,"h",y1,str2)
  
  # read the column names # scan first line so it becomes the header line
  header <- scan(fyl,nlines=1,what=character())
  
  # read the data
  buoy <- read.table(fyl,skip=2,header=FALSE)
  
  # re-attach the column names
  colnames(buoy)<-header
  
  # re-assign 999 as NA
  buoy$ATMP[buoy$ATMP==999]<-NA
  
  # add the data to the variable # data is where we are colleccting the observations
  data<-c(data,buoy$ATMP)
  
  # write the year to the screen
  cat(paste(y1))
  
  # increment the year
  y1<-y1+1
}

# built in plots
plot(data,type="l")

mm<-c(1:length(data))

# linear regression
reg1<-lm(data~mm)

# output linear regression
summary(reg1)

##################
# rejection region
qf(p = .95,df1 = 1,df2 = length(mm))

# p value  -- to see this, draw the f distrib
1 - pf(q = 11.96, df1 = 1, df2 = length(mm))


# plot of F(1, length(mm))
x <- seq(0,to = 13,by = .25)
y <- df(x,df1 = 1,df2 = length(mm))
plot(x,y,type="l",main= paste("F distribution with df =", "(1, ", as.character(length(mm)),")"))

# p value is hella small, m is slightly above 0, so  R squared value is hellla small too 


# time series models in a more sophisticated way 
# to test if there is a change in the mean valure of this time series: could do test w normal dist, test differences between means


# Download 1980-2015 text files in chunks by format

# There are different heading formats over 1980-2015, importing each period separately ----
# Creating strings of the data's URL locations using the paste command

# use apply to do all the readings, instead of the loops 

url_list1980 <- paste0("http://www.ndbc.noaa.gov/view_text_file.php?filename=42002h", c(1980:1998))
url_list1980 <- c(paste0(url_list1980, ".txt.gz&dir=data/historical/stdmet/"))

url_1999 <- "http://www.ndbc.noaa.gov/view_text_file.php?filename=42002h1999.txt.gz&dir=data/historical/stdmet/"

url_list2000 <- paste0("http://www.ndbc.noaa.gov/view_text_file.php?filename=42002h", c(2000:2003))
url_list2000 <- c(paste0(url_list2000, ".txt.gz&dir=data/historical/stdmet/"))

url_2004 <- "http://www.ndbc.noaa.gov/view_text_file.php?filename=42002h2004.txt.gz&dir=data/historical/stdmet/"

url_list2005 <- paste0("http://www.ndbc.noaa.gov/view_text_file.php?filename=42002h", c(2005:2006))
url_list2005 <- c(paste0(url_list2005, ".txt.gz&dir=data/historical/stdmet/"))

url_list2007 <- paste0("http://www.ndbc.noaa.gov/view_text_file.php?filename=42002h", c(2007:2015))
url_list2007 <- c(paste0(url_list2007, ".txt.gz&dir=data/historical/stdmet/"))

# These functions are specific settings of the read.csv() command to be used with lapply in the following step

eighty_to_osix_import <- function(x){
  read.csv(x, sep = "", header = TRUE, skip = 0)
}

osix_to_fifteen_import <- function(x){
  read.csv(x, sep = "", header = TRUE, skip = 0, check.names = FALSE)
}

## Import Data ----

# Here we lapply over our URL strings and using the according read.csv functions defined above

eighty_dflist <- lapply(url_list1980, eighty_to_osix_import)
eightydf <- do.call("rbind", eighty_dflist)
# do call is more flexible, 
ninetyninedf <- read.csv(url_1999, sep = "", header = TRUE, skip = 0)

twothousand_dflist <- lapply(url_list2000, eighty_to_osix_import)
twothousanddf <- do.call("rbind", twothousand_dflist)

twothousandfourdf <- read.csv(url_2004, sep = "", header = TRUE, skip = 0)

twothousandfive_dflist <- lapply(url_list2005, eighty_to_osix_import)
twothousandfivedf <- do.call("rbind", twothousandfive_dflist)

twothousandseven_dflist <- lapply(url_list2007, osix_to_fifteen_import)
twothousandsevendf <- do.call("rbind", twothousandseven_dflist)

## Make Headers Uniform + Misc Cleaning ----

# The steps taken here are all taken towards making the data-structure consistent 

eightydf$TIDE <- NA
eightydf$YYYY <- eightydf$YY
eightydf$YY <- NULL
eightydf <- eightydf[,c(17, 1:16)]
ninetyninedf$TIDE <- NA
twothousandfivedf$mm <- NULL
twothousandsevendf$mm <- NULL
twothousandsevendf <- twothousandsevendf[-c(1, 8707, 16884, 25618, 40026, 43114, 50533, 58476, 64038),]
twothousandsevendf$YYYY <- twothousandsevendf$`#YY`
twothousandsevendf$`#YY` <- NULL
twothousandsevendf <- twothousandsevendf[,c(17, 1:16)]
twothousandsevendf$BAR <-twothousandsevendf$PRES
twothousandsevendf$PRES <- NULL
twothousandsevendf$WD <- twothousandsevendf$WDIR
twothousandsevendf$WDIR <- NULL

## Make Single Data Frame and Clean ----

# Now that we the data is structured consistently, we rbind the different frames into one.

main_df <- rbind(eightydf, ninetyninedf, twothousanddf, twothousandfourdf, twothousandfivedf, twothousandsevendf)

# Various 99's are used as NA's, so we will recode these as they are intended

main_df[main_df=="999" | main_df=="99" | main_df=="999.0" | main_df=="99.00" | main_df=="99.0" | main_df=="9999.0"] <- NA

save(file="boston buoy 1980-2015.sav", list = "main_df")

# want to change x axis to show years instead of minutes
# use lubridate package 
library(lubridate)

#############

series <- as.numeric(main_df$ATMP)
length(series)
data <- ymd_hms("1980-01-01 00:01:00")
typeof(date) #"double"
str(date) # POSIXct [1:1], format: "1980-01-01 00:01:00"
paste0("19", main_df$YYYY[1])
main_df$MM[1]
main_df$DD[1]
main_df$hh[0]

#########
## ----load-data-----------------------------------------------------------
# Remember it is good coding technique to add additional packages to the top of
# your script 
library(lubridate) # for working with dates
library(ggplot2)  # for creating graphs
library(scales)   # to access breaks/formatting functions
library(gridExtra) # for arranging plots

# set working directory to ensure R can find the file we wish to import
# setwd("working-dir-path-here")

# daily HARV met data, 2009-2011
harMetDaily.09.11 <- read.csv(
  file="NEON-DS-Met-Time-Series/HARV/FisherTower-Met/Met_HARV_Daily_2009_2011.csv",
  stringsAsFactors = FALSE)

# covert date to Date class
harMetDaily.09.11$date <- as.Date(harMetDaily.09.11$date)

# monthly HARV temperature data, 2009-2011
harTemp.monthly.09.11<-read.csv(
  file="NEON-DS-Met-Time-Series/HARV/FisherTower-Met/Temp_HARV_Monthly_09_11.csv",
  stringsAsFactors=FALSE
)

# datetime field is actually just a date 
#str(harTemp.monthly.09.11) 

# convert datetime from chr to date class & rename date for clarification
harTemp.monthly.09.11$date <- as.Date(harTemp.monthly.09.11$datetime)

## ----qplot---------------------------------------------------------------
# plot air temp
qplot(x=date, y=airt,
      data=harMetDaily.09.11, na.rm=TRUE,
      main="Air temperature Harvard Forest\n 2009-2011",
      xlab="Date", ylab="Temperature (°C)")

## ----basic-ggplot2-------------------------------------------------------
# plot Air Temperature Data across 2009-2011 using daily data
ggplot(harMetDaily.09.11, aes(date, airt)) +
  geom_point(na.rm=TRUE)


## ----basic-ggplot2-colors------------------------------------------------
# plot Air Temperature Data across 2009-2011 using daily data
ggplot(harMetDaily.09.11, aes(date, airt)) +
  geom_point(na.rm=TRUE, color="blue", size=3, pch=18)


## ----basic-ggplot2-labels------------------------------------------------
# plot Air Temperature Data across 2009-2011 using daily data
ggplot(harMetDaily.09.11, aes(date, airt)) +
  geom_point(na.rm=TRUE, color="blue", size=1) + 
  ggtitle("Air Temperature 2009-2011\n NEON Harvard Forest Field Site") +
  xlab("Date") + ylab("Air Temperature (C)")


## ----basic-ggplot2-labels-named------------------------------------------
# plot Air Temperature Data across 2009-2011 using daily data
AirTempDaily <- ggplot(harMetDaily.09.11, aes(date, airt)) +
  geom_point(na.rm=TRUE, color="purple", size=1) + 
  ggtitle("Air Temperature\n 2009-2011\n NEON Harvard Forest") +
  xlab("Date") + ylab("Air Temperature (C)")

# render the plot
AirTempDaily


## ----format-x-axis-labels------------------------------------------------
# format x-axis: dates
AirTempDailyb <- AirTempDaily + 
  (scale_x_date(labels=date_format("%b %y")))

AirTempDailyb

## ----format-x-axis-label-ticks-------------------------------------------
# format x-axis: dates
AirTempDaily_6mo <- AirTempDaily + 
  (scale_x_date(breaks=date_breaks("6 months"),
                labels=date_format("%b %y")))

AirTempDaily_6mo

# format x-axis: dates
AirTempDaily_1y <- AirTempDaily + 
  (scale_x_date(breaks=date_breaks("1 year"),
                labels=date_format("%b %y")))

AirTempDaily_1y


## ----subset-ggplot-time--------------------------------------------------

# Define Start and end times for the subset as R objects that are the time class
startTime <- as.Date("2011-01-01")
endTime <- as.Date("2012-01-01")

# create a start and end time R object
start.end <- c(startTime,endTime)
start.end

# View data for 2011 only
# We will replot the entire plot as the title has now changed.
AirTempDaily_2011 <- ggplot(harMetDaily.09.11, aes(date, airt)) +
  geom_point(na.rm=TRUE, color="purple", size=1) + 
  ggtitle("Air Temperature\n 2011\n NEON Harvard Forest") +
  xlab("Date") + ylab("Air Temperature (C)")+ 
  (scale_x_date(limits=start.end,
                breaks=date_breaks("1 year"),
                labels=date_format("%b %y")))

AirTempDaily_2011


## ----nice-font-----------------------------------------------------------
# Apply a black and white stock ggplot theme
AirTempDaily_bw<-AirTempDaily_1y +
  theme_bw()

AirTempDaily_bw

## ----install-new-themes--------------------------------------------------
# install additional themes
# install.packages('ggthemes', dependencies = TRUE)
library(ggthemes)
AirTempDaily_economist<-AirTempDaily_1y +
  theme_economist()

AirTempDaily_economist

AirTempDaily_strata<-AirTempDaily_1y +
  theme_stata()

AirTempDaily_strata


## ----increase-font-size--------------------------------------------------
# format x axis with dates
AirTempDaily_custom<-AirTempDaily_1y +
  # theme(plot.title) allows to format the Title seperately from other text
  theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
  # theme(text) will format all text that isn't specifically formatted elsewhere
  theme(text = element_text(size=18)) 

AirTempDaily_custom


## ----challenge-code-ggplot-precip, echo=FALSE----------------------------
# plot precip
PrecipDaily <- ggplot(harMetDaily.09.11, aes(date, prec)) +
  geom_point() +
  ggtitle("Daily Precipitation Harvard Forest\n 2009-2011") +
  xlab("Date") + ylab("Precipitation (mm)") +
  scale_x_date(labels=date_format ("%m-%y"))+
  theme(plot.title = element_text(lineheight=.8, face="bold",
                                  size = 20)) +
  theme(text = element_text(size=18))

PrecipDaily

## ----ggplot-geom_bar-----------------------------------------------------
# plot precip
PrecipDailyBarA <- ggplot(harMetDaily.09.11, aes(date, prec)) +
  geom_bar(stat="identity", na.rm = TRUE) +
  ggtitle("Daily Precipitation\n Harvard Forest") +
  xlab("Date") + ylab("Precipitation (mm)") +
  scale_x_date(labels=date_format ("%b %y"), breaks=date_breaks("1 year")) +
  theme(plot.title = element_text(lineheight=.8, face="bold", size = 20)) +
  theme(text = element_text(size=18))

PrecipDailyBarA

## ----ggplot-geom_bar-subset, results="hide", include=TRUE, echo=FALSE----
# Define Start and end times for the subset as R objects that are the date class
startTime2 <- as.Date("2010-01-01")
endTime2 <- as.Date("2011-01-01")

# create a start and end times R object
start.end2 <- c(startTime2,endTime2)
start.end2

# plot of precipitation
# subset just the 2011 data by using scale_x_date(limits)
ggplot(harMetDaily.09.11, aes(date, prec)) +
  geom_bar(stat="identity", na.rm = TRUE) +
  ggtitle("Daily Precipitation\n 2010\n Harvard Forest") +
  xlab("") + ylab("Precipitation (mm)") +
  scale_x_date(labels=date_format ("%B"),
               breaks=date_breaks("4 months"), limits=start.end2) +
  theme(plot.title = element_text(lineheight=.8, face="bold", size = 20)) +
  theme(text = element_text(size=18))


## ----ggplot-color--------------------------------------------------------
# specifying color by name
PrecipDailyBarB <- PrecipDailyBarA+
  geom_bar(stat="identity", colour="darkblue")

PrecipDailyBarB


## ----ggplot-geom_lines---------------------------------------------------
AirTempDaily_line <- ggplot(harMetDaily.09.11, aes(date, airt)) +
  geom_line(na.rm=TRUE) +  
  ggtitle("Air Temperature Harvard Forest\n 2009-2011") +
  xlab("Date") + ylab("Air Temperature (C)") +
  scale_x_date(labels=date_format ("%b %y")) +
  theme(plot.title = element_text(lineheight=.8, face="bold", 
                                  size = 20)) +
  theme(text = element_text(size=18))

AirTempDaily_line

## ----challenge-code-geom_lines&points, echo=FALSE------------------------
AirTempDaily + geom_line(na.rm=TRUE) 

## ----ggplot-trend-line---------------------------------------------------
# adding on a trend lin using loess
AirTempDaily_trend <- AirTempDaily + stat_smooth(colour="green")

AirTempDaily_trend

## ----challenge-code-linear-trend, echo=FALSE-----------------------------
ggplot(harMetDaily.09.11, aes(date, prec)) +
  geom_bar(stat="identity", colour="darkorchid4") + #dark orchid 4 = #68228B
  ggtitle("Daily Precipitation with Linear Trend\n Harvard Forest") +
  xlab("Date") + ylab("Precipitation (mm)") +
  scale_x_date(labels=date_format ("%b %y"))+
  theme(plot.title = element_text(lineheight=.8, face="italic", size = 20)) +
  theme(text = element_text(size=18))+
  stat_smooth(method="lm", colour="grey")

## ----plot-airtemp-Monthly, echo=FALSE------------------------------------
AirTempMonthly <- ggplot(harTemp.monthly.09.11, aes(date, mean_airt)) +
  geom_point() +
  ggtitle("Average Monthly Air Temperature\n 2009-2011\n NEON Harvard Forest") +
  theme(plot.title = element_text(lineheight=.8, face="bold", size = 20)) +
  theme(text = element_text(size=18)) +
  xlab("Date") + ylab("Air Temperature (C)") +
  scale_x_date(labels=date_format ("%b%y"))

AirTempMonthly


## ----compare-precip------------------------------------------------------
# note - be sure library(gridExtra) is loaded!
# stack plots in one column 
grid.arrange(AirTempDaily, AirTempMonthly, ncol=1)

## ----challenge-code-grid-arrange, echo=FALSE-----------------------------
grid.arrange(AirTempDaily, AirTempMonthly, ncol=2)



