#1. Warm-Up 

# A. Write a function which takes a numeric vector and returns a named list containing its mean, variance, and median
# need to give list elements names, needs to work with only vectors of numbers

# summ <- function(x, plot = FALSE)
# {
#   if(is.numeric(x)==FALSE) # need to filter out character vectors!\
#     stop("Invalid Input. summ() only accepts numeric vectors")
#   st =  list(n=length(x),Mean=mean(x), Median=median(x), Variance =var(x))
#   if(plot==TRUE)
#   {
#     plot(x)
#     abline(h=st[["Mean"]])
#     }  
#    return (st) 
# }
summ(c(1,2,3,4,5,6,7))
# OR
data <- c(1,2,3,4,5,6,7)
stats <- summ(data)
stats # the list

data <- c("ten",15)
summ(data) # should have an error, since it's not a numeric vector, its a character vector

set.seed(17)
data <- as.integer(100*runif(20))
stats <- summ(data)
stats


set.seed(17)
data <- as.integer(100*runif(2000))
plot(data)
out <- summ(data)
abline(h=out[["Mean"]], lwd=2, col="red")  # in back of intro to R book
data[1] 
summ(data)
# plots index vs alue of element
#  should be uniform, even spread from 0 to 100
data[1]
head(data,20)



set.seed(17)
opt <-  options()
options(max.print= 10000)
data <- as.integer(100*runif(2000))
out <- summ(data)
plot(data)
sigma1 <- sqrt(out[["Variance"]])
upper <- data > out[["Mean"]] +sigma1
lower <- data < out[["Mean"]] -sigma1

x1 <- (1:length(data))*lower + (1:length(data))*upper
x <- x1
x[x>0] <- 1 #so yo ucan take the vectors of 1 and multiply it by the data vector to get x (index) and y's (1)'s 

y <-  data*x
y <-  data


# Parts of a Function 
# formals: arguments
# body: rest of the code
# environment: usually in the global env.


Scoping 

f <- function(){
  x=1
  y=2
  c(x,y)
}
f()
x
#x is not found, it's loval to the function, can't see it 
rm(f)


x <- 2
g <- function(){
  y <- 1
  c(x,y)
  
}
g()
# get [1] 2 
# since x is now in the global environment

y
#object y is not found 