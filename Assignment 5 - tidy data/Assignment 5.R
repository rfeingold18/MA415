# Table 1 
# based on values produced by a function called preg.r
#  
# you'll note that the values for Table 1 are in a variable
# called preg.  And you should notice that preg is not a data.frame

source("preg.r") # preg.r made a primary version of table 1, called "preg" but it's not a data frame, its still a table.
library(tidyr)
library(stringr)

# make preg into  data.frame, called p
p <- as.data.frame(preg)
# the row names are not data, need to get the "names" of the people as a column
p <- cbind(p,names=row.names(p))
# but now two columns have "names" need to get rid of the first column with row names, rearrange data s.t the last column is the first column
row.names(p) <- NULL
p <- p[,c(3,1,2)]
p
# THIS IS TABLE 1 

table2 <- t(p)
table2

# Turn table 1 into attribute-key pairs
gather(p,treatment,value, -names)
# rename the columns
colnames(p)
colnames(p) <- c("names", "a", "b")
table3 <- gather(p, treatment, value,-names)
table3
# THIS IS TABLE 3
# and use spread to see the table in Table1 form
spread(table3, treatment, value) # treatment is the varaible you are looking at (columns)
# and in Table2 form
spread(table3, names, value) # name is the variable you are looking at (columns)


# TABLE 4

library(foreign)
library(stringr)
library(plyr)
library(reshape2)
source("xtable.r")

# Data from http://pewforum.org/Datasets/Dataset-Download.aspx

# Load data from .sav file 

pew <- read.spss("pew (1).sav")
pew <- as.data.frame(pew)

head(pew)
# building new table, religion, want only certain columns from pew data frame
religion <- pew[c("q16", "reltrad", "income")] # only want religion and income 
religion$reltrad <- as.character(religion$reltrad) #makes observations strings                                  
religion$reltrad <- str_replace(religion$reltrad, " Churches", "") #next few lines is cleaning the responses given
religion$reltrad <- str_replace(religion$reltrad, " Protestant", " Prot")
religion$reltrad[religion$q16 == " Atheist (do not believe in God) "] <- "Atheist"
religion$reltrad[religion$q16 == " Agnostic (not sure if there is a God) "] <- "Agnostic"
religion$reltrad <- str_trim(religion$reltrad)
religion$reltrad <- str_replace_all(religion$reltrad, " \\(.*?\\)", "") #gets rid of all funny characters in people's answer to surveys
# changes long descriptions in income variable to shorter, mathematical expressions
religion$income <- c("Less than $10,000" = "<$10k", 
                     "10 to under $20,000" = "$10-20k", 
                     "20 to under $30,000" = "$20-30k", 
                     "30 to under $40,000" = "$30-40k", 
                     "40 to under $50,000" = "$40-50k", 
                     "50 to under $75,000" = "$50-75k",
                     "75 to under $100,000" = "$75-100k", 
                     "100 to under $150,000" = "$100-150k", 
                     "$150,000 or more" = ">150k", 
                     "Don't know/Refused (VOL)" = "Don't know/refused")[religion$income]
religion$income <- factor(religion$income, levels = c("<$10k", "$10-20k", "$20-30k", "$30-40k", "$40-50k", "$50-75k", 
                                                      "$75-100k", "$100-150k", ">150k", "Don't know/refused"))
#  makes all values in that columns split into factors, the levels being the different tiers of income
counts <- count(religion, c("reltrad", "income"))
# counts is a new data frame, formed by merging religion and the column vectors income and frequency 

names(counts)[1] <- "religion"

xtable(counts[1:10, ], file = "pew-clean.tex")

# Convert into the form in which I originally saw it -------------------------

raw <- dcast(counts, religion ~ income)
xtable(raw[1:10, 1:7], file = "pew-raw.tex")
# counts is a tidy version of table 4 in pdf 

# TABLE 5

library(reshape2)
source("xtable.r")

df <- data.frame(row = LETTERS[1:3], a = 1:3, b = 4:6, c = 7:9)
xtable(df, "melt-raw.tex")

dfm <- melt(df, id = "row")
names(dfm)[2] <- "column"
xtable(dfm, "melt-output.tex")

df
dfm
# df is the raw data, TABLE 5a
# dfm is the molten data, TABLE 5b

# TABLE 6  
# going from Table 4 to table 6

library(tidyr)
library(dplyr)
a <- raw %>% gather(attributes, values, -religion) 
b <- arrange(a,religion) #sorting the tidied version of a by relgion # this is TABLE 6
head(a)
head(b)

# TABLE 7 
options(stringsAsFactors = FALSE)
library(lubridate)
library(reshape2)
library(stringr)
library(plyr)
source("xtable.r")

#  import billboard csv file 
raw <- read.csv("billboard.csv") 
# only want certain columns
raw <- raw[, c("year", "artist.inverted", "track", "time", "date.entered", "x1st.week", "x2nd.week", "x3rd.week", "x4th.week", "x5th.week", "x6th.week", "x7th.week", "x8th.week", "x9th.week", "x10th.week", "x11th.week", "x12th.week", "x13th.week", "x14th.week", "x15th.week", "x16th.week", "x17th.week", "x18th.week", "x19th.week", "x20th.week", "x21st.week", "x22nd.week", "x23rd.week", "x24th.week", "x25th.week", "x26th.week", "x27th.week", "x28th.week", "x29th.week", "x30th.week", "x31st.week", "x32nd.week", "x33rd.week", "x34th.week", "x35th.week", "x36th.week", "x37th.week", "x38th.week", "x39th.week", "x40th.week", "x41st.week", "x42nd.week", "x43rd.week", "x44th.week", "x45th.week", "x46th.week", "x47th.week", "x48th.week", "x49th.week", "x50th.week", "x51st.week", "x52nd.week", "x53rd.week", "x54th.week", "x55th.week", "x56th.week", "x57th.week", "x58th.week", "x59th.week", "x60th.week", "x61st.week", "x62nd.week", "x63rd.week", "x64th.week", "x65th.week", "x66th.week", "x67th.week", "x68th.week", "x69th.week", "x70th.week", "x71st.week", "x72nd.week", "x73rd.week", "x74th.week", "x75th.week", "x76th.week")]
# change second column name from "artist.inverted" to just "artist"
names(raw)[2] <- "artist"
raw$artist <- iconv(raw$artist, "MAC", "ASCII//translit")
raw$track <- str_replace(raw$track, " \\(.*?\\)", "")
names(raw)[-(1:5)] <- str_c("wk", 1:76)
raw <- arrange(raw, year, artist, track)
head(raw)
# if track name is longer than 20 characters, shortens it
long_name <- nchar(raw$track) > 20
help(paste0)
raw$track[long_name] <- paste0(substr(raw$track[long_name], 0, 20), "...")
head(raw)
# raw if the data frame for TABLE 7
xtable(raw[c(1:3, 6:10), 1:8], "billboard-raw.tex")

# TABLE 8

clean <- melt(raw, id = 1:5, na.rm = T) # removes NA values
clean$week <- as.integer(str_replace_all(clean$variable, "[^0-9]+", ""))
clean$variable <- NULL

clean$date.entered <- ymd(clean$date.entered)
clean$date <- clean$date.entered + weeks(clean$week - 1)
clean$date.entered <- NULL
head(clean)
# up to here Wickham helped remove NA values and mde a new colum called week, was able to remove wk1-wk75 columns
clean <- rename(clean, c("value" = "rank"))
clean <- arrange(clean, year, artist, track, time, week)
# clean <- clean[c("year", "artist", "time", "track", "date", "week", "rank")]
head(clean) # THIS IS TABLE 8

# TABLES 13 
# a song dataset that stores "artist, song name, and time" 
# a ranking dataset that gives the "rank" of the "song" in each week"
songs <-  distinct(select(clean,artist,track, time))
id <- 1:nrow(songs)
songs <- cbind(id,songs)
head(songs)
# THIS IS PART 1 OF TABLE 13
two <- arrange(clean, artist, date)
artistid <- distinct(two, artist)
id <- 1:nrow(artistid)
artistid <- cbind(id, artistid)
two <- right_join(artistid, two, by="artist")
two <- select(two, id, date, value)
head(two)
