# Graphics and GGplot2


# Work in layers like photoshop or gimp
# Based on a book called Grammar of Graphic by Wilkerson- better for publication 
# Need to hand data in a data frame
# NO 3D graphics, graph theory graphs (but igraph does this)
# Doesn't support interactive graphs (ggvis does this) (also plotly and shiny useful packages)

# gramatical elements
# 1. Data- needs to be organized 
# 2. Aesthetic- the elements of the data being mapped onto x and y, they need to be assigned 
# 3. Geometric objects- bar charts, scatterplots, lines
# 4. Statistical transformation- want to alter data for purposes of graphing 
# 5. Scale
# 6. Coordinate systems 
# 7. Position adjustments- if points overplot, and you have no indication of the size of the data set, you can jitter the points to prevent overlap
# 8. Faceting- putting more than one graphic on a page
# 9. Themes- if you are making a publication that needs a certain look 


library(ggplot2)
data("mtcars") #mtcars is a dataframe 
head(mtcars)

df <-  mtcars[,c("mpg","cyl","wt")] #mpg is cont, so is wt but cyl is a factor #taking a subset of the mtcars data
# typeof(mtcars$cyl) says its a "double"
# need to change it into a factor

df$cyl <- as.factor(df$cyl)
head(df) #now have a subset of a column
levels(df$cyl) #NEED TO UNDERSTAND THE DATA

# quickplot: qplot, should be just as easy as the uilt in graphic functions 
qplot(x=mpg,y=wt, data=df, geom = "point")
qplot(mpg,wt,data=df,geom=c("point","smooth")) #better than showing just points, highlights a region, makes a line
qplot(x=mpg,y=wt,data=df, color=cyl, shape=cyl,size=3 ) #seperates cyl by color, makes a key 

# another example of qplots, different types of plots with same data
set.seed(17)
wdata <- data.frame(
  sex=factor(rep(c("F","M"), each=200)),  #400 people, 200 males, 200 females, average is 55 and 58 respectively 
  weight=c(rnorm(200,55),rnorm(200,58))
  
)
head(wdata)

qplot(sex,weight,data=wdata,
      geom="boxplot",fill=sex)  #fill color indication of sex


qplot(sex,weight,data=wdata,
      geom="violin",fill=sex)  # different shape

qplot(sex,weight,data=wdata,
      geom="dotplot",stackdir="center", binaxis="y", dotsize=0.05) 

qplot(sex,weight,data=wdata,
      geom = "histogram", fill = sex)
      
qplot(sex,weight,data=wdata,
      geom = "density", color = sex, linetype = sex)


#### same thing with ggplot not qplot


ggplot(data = mtcars, aes(x=wt, y = mpg)) +
  geom_point() # get scatterplot like before

a <- ggplot(data = mtcars, aes(x=wt, y=mpg)) # take main elements of the graphical parameters into a list

a + geom_point(size=2, shape=23)


ggplot(wdata, aes(x=weight)) + geom_density() # get density plot

# definition of data + geometric
ggplot(wdata, aes(x=weight)) + stat_density()

a <- ggplot(wdata, aes(x=weight))
# flexibility 


# a +
# geom_area()
#geom_density()
#geom_ dotplot, freqpoly, histogram, stat_ecdf, stat_qq

# mtcar -- x=st y = mpg
# geom_point
# geom_smootn, qualtile, rug,jitter,text

##########################
# Plotting 2 lines together
# starts Class 11

# data
df1 <- as.data.frame(matrix(data=c(0,3,2,4,5,5), nrow = 3,byrow = TRUE))

df2 <- as.data.frame(matrix(data=c(1,4,2,5,3,9), nrow = 3,byrow = TRUE))

# make two simple data frames
df1
df2
# two ways to plot a line
ggplot(data = df1) + geom_line(aes(x=V1, y=V2)) + 
  ggtitle("ggplot(df1) + geom_line(aes(x=V1, y=V2))")

# heres data, geom line tells you x and y, and then you attach the title 

ggplot(data = df1,aes(x=V1, y=V2)) + geom_line() + 
  ggtitle("ggplot(df1,aes(x=V1, y=V2)) + geom_line()")

# did same thingm switched where you put the aesthetic, put aesthetic into the geometry, not equivalent statements!
# 
# So now you know how to do two

ggplot(data = df1) + geom_line(aes(x=V1, y=V2), color = "blue") + 
  geom_line(data = df2, aes(x=V1, y=V2), color = "red") + 
  ggtitle("Two Lines") 

#puts themm in the same chart

#interested in density of weight data
#didn't tell it to differentiate between males and females, we want to compare the two

ggplot(wdata, aes(x=weight)) + geom_density() +
  ggtitle("ggplot(wdata, aes(x=weight)) + geom_density()")

ggplot(wdata) + geom_density(aes(x=weight, color = sex) ) +
  ggtitle("ggplot(wdata) + geom_density(aes(x=weight, color = sex))")

# only obsv is weight, but we have a specification, the sex, so we differentiate by color
#added a title

ggplot(wdata, aes(x=weight, fill = sex)) + geom_density() +
  ggtitle("ggplot(wdata, aes(x=weight, fill = sex))")

#do it again but aesthtic in main body, also used fill

# say we want to create a table, has M/F on top, and indexed going down with weights with mean and s.d at the bottom of the columns
# want two data frames one with weight and one with the mean/s.d for F/M
# dplyr allows you to do this?
# this allows us to convey more information! 



library(dplyr)
m1 <- summarize(group_by(wdata, sex), mean(weight)) 
m1
#not as good, need to name the mw. 

m <- summarize(group_by(wdata, sex), mw = mean(weight)) 
#summarizes data and groups it by sex, mw is a variable name
m  
# m is the table
#sex is a factor 

#graph
#alpha parameter sets the opaqueness
#geom=density makes it a density graph
#verticle line plotted is the m
#since its working with data frames, can use m values directly, only want a line use one variable mw
# decided that you have a variable .4 which is annoying, which you put in the aesthetic, assumed that there was a variable calld .4 


ggplot(wdata, aes(x=weight, fill = sex, alpha = .4)) + 
  geom_density() +
  geom_vline(data = m, aes(xintercept = mw), 
             color = "black", linetype = "dashed")

# and, finally, get rid of the .4 in the legend

ggplot(wdata) + 
  geom_density(aes(x=weight, fill = sex), alpha = .4) +
  geom_vline(data = m, aes(xintercept = mw), 
             color = "black", linetype = "dashed")
# didnt put alpha as part of the aesthetixc


#how to change overall appearance

library(ggthemes)
??ggthemes

ggplot(wdata) + 
  geom_density(aes(x=weight, fill = sex), alpha = .4) +
  geom_vline(data = m, aes(xintercept = mw), 
             color = "black", linetype = "dashed") +
  theme_wsj()


