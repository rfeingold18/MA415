## Sean Anderson -- dplr & pipes
## select, filter, group_by, summarise, arrange, join, mutate

library(dplyr)

pantheria <-
  "http://esapubs.org/archive/ecol/E090/184/PanTHERIA_1-0_WR05_Aug2008.txt"

download.file(pantheria, destfile = "mammals.txt")

mammals <- read.table("mammals.txt", sep = "\t", header = TRUE, 
                      stringsAsFactors = FALSE) # so we don't end up with a ton of factors (extra variables)
is.data.frame(mammals) # TRUE

names(mammals) <- sub("X[0-9._]+", "", names(mammals))
names(mammals) <- sub("MSW05_", "", names(mammals))

mammals <- dplyr::select(mammals, Order, Binomial, AdultBodyMass_g, 
                         AdultHeadBodyLen_mm, HomeRange_km2, LitterSize)
#package::: name of the function inside of it, use if you haven't loaded dplyr

mammals <- select(mammals, Order, Binomial, AdultBodyMass_g, 
                         AdultHeadBodyLen_mm, HomeRange_km2, LitterSize)
# picks out these columns by name of variable at top of column in data frame

names(mammals) <- gsub("([A-Z])", "_\\L\\1", names(mammals), perl = TRUE)
names(mammals) <- gsub("^_", "", names(mammals), perl = TRUE) #removes coding from variable names

mammals[mammals == -999] <- NA #store not available data as NA not 999, NA will be corerced into any type of data needed
names(mammals)

names(mammals)[names(mammals) == "binomial"] <- "species" #changes 'binomial' variable to 'species'

mammals <- dplyr::tbl_df(mammals) # for prettier printing

mammals

glimpse(mammals) # $ sign because they are variables inside a data frame


# verbs:  select, filter, arrange, mutate, summarise

########################### select

select(mammals, adult_head_body_len_mm)
select(mammals, adult_head_body_len_mm, litter_size)
select(mammals, adult_head_body_len_mm:litter_size)
select(mammals, -adult_head_body_len_mm) #gets everything but these
select(mammals, contains("body"))
select(mammals, starts_with("adult"))
select(mammals, ends_with("g"))
select(mammals, 1:3)

################################### filter

filter(mammals, adult_body_mass_g > 1e7)[ , 1:3] # uses logical comparisons
filter(mammals, species == "Balaena mysticetus")
filter(mammals, order == "Carnivora" & adult_body_mass_g < 200)

################################# arranging rows

arrange(mammals, adult_body_mass_g)[ , 1:3]
arrange(mammals, desc(adult_body_mass_g))[ , 1:3]
arrange(mammals, order, adult_body_mass_g)[ , 1:3]

##################################### mutating columns

glimpse(mutate(mammals, adult_body_mass_kg = adult_body_mass_g / 1000)) #creates new variable, adult body weight in kg
glimpse(mutate(mammals, 
               g_per_mm = adult_body_mass_g / adult_head_body_len_mm))
glimpse(mutate(mammals,
               g_per_mm = adult_body_mass_g / adult_head_body_len_mm,
               kg_per_mm = g_per_mm / 1000))
x <- mutate(mammals, adult_body_mass_kg = adult_body_mass_g / 1000)
x 
# one more variable than mammals

############################################ summarizing columns

summarise(mammals, mean_mass = mean(adult_body_mass_g, na.rm = TRUE)) # removes NA to calculate mean **always need to remove NA data/ understand it
head(summarise(group_by(mammals,order),
               mean_mass = mean(adult_body_mass_g, na.rm = TRUE)))


##########  pipes %>%  ctrl-shft-M

library(magrittr)
x <- rnorm(10)
sort(x)
x %>% max
max(x)
################ Workflows

### example
library(dplyr)
library(bigrquery) 
# sql<-"select * from [publicdata:samples.shakespeare]"
# shakespeare <-query_exec(sql, project = "dark-mark-818",max_pages=Inf)

# step 1:  GET the data -- word index for the works of Shakespeare

shakespeare <- read.csv("shakespeare.csv", head=TRUE, stringsAsFactors = FALSE   )
head(shakespeare)
# word - count - corpus - data
str(shakespeare)
# fix the problem of words in diff cases
head(filter(shakespeare, tolower(word)=="henry"))

# now aggregate by lower case words, corpus, corpus data 
# under gro have a new variable for word_count

shakespeare<-mutate(shakespeare, word=tolower(word))
shakespeare
grp<-group_by(shakespeare, word, corpus, corpus_date)
grp
shakespeare<-summarize(grp, word_count=sum(word_count))
shakespeare
head(filter(shakespeare, tolower(word)=="henry"))

# for example, henry -- eaech in a different work

grp <- group_by(shakespeare, word)
cnts <- summarize(grp, count=n(), total = sum(word_count))
word.count <- arrange(cnts, desc(total))
head(word.count)
tail(word.count)

########################################

# A better way -- no interim objects

library(magrittr)

word.count2 <- group_by(shakespeare, word) %>%
  summarize(count=n(), total = sum(word_count)) %>%  ### see above
  arrange(desc(total))

head(word.count2)

# compount assignment operator
# this says pass word.count to a filter and write over word.count 
# with the results

# put the pieces here

word.count %<>% filter(nchar(word)>4, count<42)
 # coumpound assignment pipe, starts with what's in word.count, filters it, and reassign the value after the filter back into word count

head(word.count)


###### Now tidyr

library(tidyr)

top8<-word.count$word[1:8]
top8
top8 <- filter(shakespeare, word%in%top8)%>%
  select(-corpus_date)

## Note that Hadley Wickham suggests simpler code as
## top8<-shakespeare %>% semi_join(head(word.count,8))

head(top8)

## now make a wide table
# spread is a verb in tidyr
top8.wide<- spread(top8, word, word_count)

head(top8.wide, n=10)
# see top 8 words as columns , and obvs/counts for each of the top 8 words

#OK -- but we have missing values
#So, fix them

top8.wide<- spread(top8, word, word_count, fill=0)

head(top8.wide, n=10)


# 
# For comparison, how might we do this with the more traditional reshape function:
#   
# top8<-data.frame(top8) # needs to be a data frame
# tmp<-reshape(top8, v.names="word_count", idvar="corpus", timevar="word", direction="wide")
# head(tmp)

########################  and now visualize with ggplot2


library(ggplot2)

ggplot(word.count, aes(count, total)) + 
  geom_point(color="firebrick") + 
  labs(x="Number of works a word appears in", 
       y="Total number of times word appears")

## Look at the range of values. Let's get more information on the page
# with a log scale, stretch data in easier way to interpret


ggplot(word.count, aes(count, total)) + 
  geom_point(color="firebrick") +
  labs(x="Number of works a word appears in", 
       y="Total number of times word appears") +
  scale_y_log10()


ggplot(word.count, aes(count, total)) + 
  geom_point(color="firebrick")+
  labs(x="Number of works a word appears in", 
       y="Total number of times word appears") +
  scale_y_log10() + 
  stat_smooth()

# the smoothe alerts you to the fact that 
# low frequency words conditioned by the number of works
# in which they appear are low frequency overall


word.stats1 <- group_by(word.count, count, total) %>% 
  summarize(cnttot=n())

head(word.stats1)

word.count <- inner_join(word.count, word.stats1, by=c("count", "total"))

ggplot(word.count, aes(count, total, size=cnttot)) +
  geom_point(color = "firebrick") +
  labs(x = "Number of Works a word appears in",
       y = "Total number of times word appears") +
  scale_y_log10() +
  scale_size_area(max_size = 20) +
  theme(legend.position = "none")

# What's that big red blob in the lower left?

ggplot(word.count, aes(count, total)) +
  geom_jitter(alpha=0.1,position = position_jitter(width = .2), 
              color="firebrick") +
  labs(x = "number of works a word appears in",
       y = "Total number of times word appears") +
  scale_y_log10()

# that seems better
# transparency shows frequency. not size of the dot

ggplot(word.count, aes(count, total)) +
  geom_jitter(alpha=0.1,position = position_jitter(width = .2), 
              color="firebrick") +
  labs(x = "number of works a word appears in",
       y = "Total number of times word appears") +
  scale_y_log10() + 
  stat_smooth()

word.stats2<-group_by(word.count, count)%>%
  summarize(max=max(total), min=min(total))

head(word.stats1)

word.count<-inner_join(word.count, word.stats2, by=c("count"))

ggplot(word.count, aes(count, total)) +
  geom_jitter(alpha=0.1,position = position_jitter(width = .2), 
              color="firebrick") +
  labs(x="Number of works a word appears in", 
       y="Total number of time word appears") +
  scale_y_log10() +
  geom_text(data=filter(word.count, total==max), 
            aes(count, total, label=word), size=3) +
  geom_text(data=filter(word.count, total==37 & min==37), 
            aes(count, total, label=word), 
            position=position_jitter(height=0.2), size=3)


# tidyr:  gather, spread, unite, seperate


library(tidyr)
library(dplyr)
head(mtcars)

## add a column with car names as a new columns

mtcars$car <- rownames(mtcars)

head(mtcars)
mtcars <- mtcars[, c(12, 1:11)] #put new 'car' column at the begining of the table and wiped out the row names so it looks like original
row.names(mtcars) <- NULL
head(mtcars)

#####################################  gather
# Gather takes multiple columns and collapses into key-value pairs, 
# duplicating all other columns as needed. 
# You use gather() when you notice that 
# you have columns that are not variables.

# lets observations on rows and variables on the columns 
# todyr creates key value pairs 
gather(mtcars, attribute, value, -car)
head(mtcars)
# turned table into long skinny arrangement

# From http://stackoverflow.com/questions/1181060 

stocks <- data_frame( time = as.Date('2009-01-01') + 0:9, 
                      X = rnorm(10, 0, 1), 
                      Y = rnorm(10, 0, 2), 
                      Z = rnorm(10, 0, 4) )

stocks
gather(stocks, stock, price, -time) #organized along the time, we don't want it included
# alternatively
stocks %>% gather(stock, price, -time)

# Tidyr

# get first observation for each Species in iris data -- base R 
mini_iris <- iris[c(1, 51, 101), ] 
mini_iris
# gather Sepal.Length, Sepal.Width, Petal.Length, Petal.Width 

gather(mini_iris, key = flower_att, value = measurement, 
       Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) 

# same result but less verbose 

gather(mini_iris, key = flower_att, value = measurement, -Species)

# repeat iris example using dplyr and the pipe operator 
mini_iris

mini_iris <- iris %>% group_by(Species) %>% 
  slice(1) 

mini_iris

mini_iris %>% gather(key = flower_att, value = measurement, -Species)


# gather columes mpg throught gear, leaving car and carb as they are

mtcarsNew <- mtcars %>% gather(attribute, value, mpg:gear)

head(mtcarsNew)

# Spread a key-value pair across multiple columns.

mtcarsSpread <- mtcarsNew %>% spread(attribute, value)
head(mtcarsSpread)

