## for loops

## set up a matrix A
set.seed(17)
A <- matrix(data = as.integer(100*runif(40)), nrow = 4,byrow = TRUE)

# calculate the sums of the columns
a <- NULL
for(i in 1:10){
  a <- c(a,sum(A[,i]))
}
a

## or
b <- colSums(A)
b
#########################################################################
# lists
set.seed(17)
options(scipen = 999, digits = 3)
list(1,2,3)
a <- c("a", "b", "c")
b <- 4:6
c <- runif(3)

mylist <- list(a,b,c)
mylist
##  when applied to a list
##  [ returns a list "Preserving"
##  [[ returns simplest data structure for the output
##  

mylist[1]
mylist[2]

mylist[[1]]
mylist[[2]]

#####################################################################
# dataframes and lists

head(mtcars)

row.names(mtcars)
colnames(mtcars)

#values for mpg
is.data.frame(mtcars)
is.list(mtcars)

mtcars$mpg

m <- mtcars

mtcars[[1]]
str(mtcars$mpg)
str(mtcars[[1]])
mtcars[1]

str(mtcars[1])
mtcars["mpg"]
head(mtcars)
typeof(mtcars$cyl)
mtcars$cyl <- factor(mtcars$cyl)

#######################################################################
## for loops

## set up a matrix A
set.seed(17)

A <- matrix(data = as.integer(100*runif(40)), nrow = 4,byrow = TRUE)
A

# calculate the sums of the columns
a <- NULL
for(i in 1:10){
  
  a <- c(a,sum(A[,i]))
  
}
a

## or

b <- colSums(A)
b


#################################################
# vectors
#2 

x <- seq(3, 6, by = .1)
head(x)
t <- exp(x)*cos(x)

plot(t, type="l", col="blue")

?plot
points(exp(x), col="red")
points(cos(x), col="green")

#3

s <- 0:4
outer(s,s,"+")



