setwd("~/Home/MA415")
###read in
corn = read.csv2("corn.csv",sep = ",",stringsAsFactors = T)

###glimpse
colnames(corn)
head(corn)

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
###omit NAs

#### remember this?
#corn %<>% select(-matches("Ag.District"))

#### if there is too much NA, check them one by one is time consuming and tiring
indi = rep(0,ncol(corn))
for(i in 1: ncol(corn)){indi[i] = sum(!is.na(corn[,i]))}
which(indi==0)
#[1]  4  8  9 10 11 12 13 15 21
tidycorn = corn[,-c(which(indi==0))]
rm(indi,corn)

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

###re-scan dataset
# useless data, all same values for the variable, can drop them 
table(tidycorn$Domain,corn$Domain.Category)
table(tidycorn$Commodity)
table(tidycorn$watershed_code)
table(tidycorn$Program)
table(tidycorn$Geo.Level)

#these are variables that do not vary in this scale. If our target dataset is just in this file, we can just drop them.

###Stable information of this dataset
Info = tidycorn[,c("Domain","Domain.Category","Commodity","watershed_code","Program","Geo.Level")][1,]

###Drop stable variables
dr = function(name){return(which(colnames(tidycorn)==name))}
tidycorn = tidycorn[,-c(dr("Domain"),dr("Domain.Category"),dr("Commodity"),dr("watershed_code"),dr("Program"),dr("Geo.Level"))]
rm(i,dr)
# should only have 6 columns left 
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
### Period and State#(optional)  
####Converge char to a more comfortable format
library(stringr)
#Change month into number form (january = 01)
#Change State into lower case
month.abb.c = toupper(month.abb)
tidycorn$State = tolower(tidycorn$State)

# gsub function: input a variable string, set a pattern, and gives a replacement SHOULD CHANGE PERIOD COLUMN
for(i in 1:length(month.abb.c)){
  tidycorn$Period = gsub(pattern = month.abb.c[i],replacement = i,x = tidycorn$Period)
}
rm(i,month.abb.c)
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

##### ok now we need to setup the factors (FOR COLUMNS SUCH AS STATE)
##### or we could do "stringsAsFactors = T" when read in our data
tidycorn$Year <- factor(tidycorn$Year)
levels(tidycorn$Year)

tidycorn$Period <- factor(tidycorn$Period)
levels(tidycorn$Period)

tidycorn$State <- factor(tidycorn$State)
levels(tidycorn$State)

tidycorn$State.ANSI <- factor(tidycorn$State.ANSI)
levels(tidycorn$State.ANSI)


tidycorn$Value = as.character(tidycorn$Value)

##corn6.sav

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

## now we need to operate on the Data.Item column 
## eliminate the redundancies
table(tidycorn$Data.Item)
# CORN,          GRAIN - PRICE RECEIVED, MEASURED IN $ / BU    
# CORN,          GRAIN - SALES,          MEASURED IN PCT OF MKTG YEAR
# CORN, ON FARM, GRAIN - DISAPPEARANCE,  MEASURED IN BU 

tidycorn$Data.Item = as.character(tidycorn$Data.Item)
library(tidyr)
tidycorn %<>% separate(Data.Item, into = paste("V",1:4,sep = ""),sep = ", ",remove = TRUE)
View(tidycorn)

table(tidycorn$V1)###drop it!
tidycorn$V1 = NULL

sum(!is.na(tidycorn$V4))###can not drop!

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

table3 = subset(tidycorn,subset = V2=="ON FARM")
tidycorn = tidycorn[-as.integer(rownames(table3)),]
colnames(table3)
#"Year"       "Period"     "State"      "State.ANSI" "V2"         "V3"         "V4"         "Value"
##V3 ---> V2
##V4 ---> V3
##V2 ---> V4
colnames(table3) = c("Year","Period" ,"State" ,"State.ANSI","V4","V2","V3","Value" )
table3 = table3[,c("Year"   ,    "Period"  ,   "State"    ,  "State.ANSI",       "V2"   ,      "V3"   ,      "V4"   ,      "Value")]
table3$Value = gsub(pattern = ",",replacement = "",x = table3$Value)
table3$Value = as.numeric(table3$Value)

tidycorn = rbind(tidycorn,table3)
tidycorn$Value = as.numeric(tidycorn$Value)
rm(table3)
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

tidycorn %<>% separate(V2, into = paste("VV",1:2,sep = ""),sep = " - ",remove = TRUE)

table(tidycorn$VV1)

tidycorn$VV1 = NULL

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

##save(file = "corndog.sav", list = "corn")

save(tidycorn,file = "tidycorn.Rdata")
rm(list = ls())

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

load("tidycorn.Rdata")

###Play with data
library(data.table)
library(ggplot2)

t = subset(tidycorn,subset = VV2=="SALES")

tt = subset(t,subset = State=="colorado")

ggplot(tt) + geom_point(aes(x=Period,y=Value,col=Year)) + facet_wrap(~Year) + ggtitle("CORN - SALES IN PCT OF MKTG YEAR - COLORADO")

ggplot(tt) + geom_smooth(aes(x=Period,y=Value,group=Year,col=Year),alpha = 0.05) + ggtitle("CORN - SALES IN PCT OF MKTG YEAR - COLORADO")

library(lubridate)
tt$time = paste(tt$Year,tt$Period,"01",sep = "-")
tt$time = ymd(tt$time)

ggplot(tt) + geom_line(aes(x = time,y = Value)) + ggtitle("CORN - SALES IN PCT OF MKTG YEAR - COLORADO")

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

#table(table2$Year)

t = subset(tidycorn,subset = VV2=="SALES")
t = as.data.table(t)

t = t[,list(Value=median(Value)),by=State]
#dplyr::group_by()
#aggregate()
#do the same things 
#data.table do it fast

statmap = map_data("state")
t_map = merge(t,statmap,by.x = "State", by.y = "region",all.y = T)
t_map = arrange(t_map,order,group)

theme_clean <- function(base_size = 12) {
  require(grid)
  theme_grey(base_size) %+replace%
    theme(
      axis.title      =   element_blank(),
      axis.text       =   element_blank(),
      panel.background    =   element_blank(),
      panel.grid      =   element_blank(),
      axis.ticks.length   =   unit(0,"cm"),
      axis.ticks.margin   =   unit(0,"cm"),
      panel.margin    =   unit(0,"lines"),
      plot.margin     =   unit(c(0,0,0,0),"lines"),
      complete = TRUE
    )
}

ggplot(t_map,aes(x=long, y=lat, group=group)) +
  geom_polygon(linetype = 2, size = 0.1, colour = "lightgrey",aes(fill = Value)) + 
  expand_limits(x = t_map$long, y = t_map$lat) + 
  coord_map( "polyconic") + theme_clean()
#  geom_path( data = statmap, color = "darkgrey")

rm(statmap,t,theme_clean)

##############Notice:
##############Other ways to divide table, e.g. table contain data of a certain state, is also reasonable.


