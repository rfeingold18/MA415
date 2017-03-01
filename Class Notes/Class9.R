#1.c
#The function takes a list as argument and outputs all the character vectors

char_in_list <- function(list) 
{
  if(length(list) == 0)
    stop("err 1: List is empty.")
  
  #Output the indices of elements in the list that are characters, then print it  
  
  printID = which(lapply(list, is.character) %in% TRUE )
  print(list[printID])
  
  
  if(length(printID) == 0)
    stop("err 2: There are no charaters in the list.")
}


b1 <- list(c("aa", "bb"), "a", "b", 1)

b <- list(c("this", "is", "a", "list", "item"), 3:5, 
          "a b c d", 1023, c("Get", "rid", "of", "those", "numbers"))

# 
char_in_list(b)
# 
a <- c( T, F, F, T)
which(a)
# 
# formals(print_char_in_list)
# 
# body(print_char_in_list)
# 
# 
# environment(print_char_in_list)


b[[3]]


is.character(b1)
length(b)


val <- 65:96 # whatever values you want the equivalent characters for
mode(val) <- "raw" # set mode to raw
# alternatively, val <- as.raw(65:96)
a   <- sapply(val, rawToChar)
res <- do.call(paste, expand.grid(a, a))




#CHANGE OROBLEM 1.C SUPPLEMENTAL
#such that is.character function also runs through a list of list for chracters
#chapter 12 for graphics help 

#1.d


# (d) Write a function with an argument k which simulates a symmetric random walk on the integers, stopping when the walk reaches k (or −k ). A random walk on the integers is a sequence
# $X_1,X_2,X_3$,... with $X_0=0$ and $X_i=X_{i+1}+D_i$ wherethe $D_i$ are independentwith $P(D_i=+1)=P(D_i=−1)=1/2$.

# set.seed(17)

f1d <- function(k){
  
  # check to make sure input is an integer.
  if(as.integer(k) != k)stop('f1d() requires an integer value to start.')
  
  i = 1
  x = 0
  while(abs(x[i])!=k){
    x[i+1] = x[i] + sample(c(-1,1))
    i = i+1
  }
  return(x)
}

#(example)

rand <- f1d(100)
plot(rand,type="l")




## 2 Moving Average
# a.

ma3 <- function(x)
{
  n <- length(x)
  y <- ((x[-c(n-1,n)] + x[-c(1,n)] + x[-c(1,2)])/3)
  plot(y)
  return(y)
}
test = runif(10)
ma3(test)
test = 1:10
ma3(test)

#### (b) Write a function which takes two arguments, x and k, and calculates the moving average of x of length k. 
makb = function(x,k)
{
  n = length(x)
  if (k > n) {return("cant generate moving average")}
  m = outer(1:k,0:(n-k),"+")
  x = matrix(x[m], nrow = k, ncol = (n - k + 1))
  return(as.vector(colMeans(x)))
}
makb(test,k = 6)


#### (c) How does your function behave if k is larger than (or equal to) the length of x?

mak(test, 10)#return the mean of the series
mak(test, 11)#return message



#### (d) You can (and should) return an error in this case. Use the stop() function. Are there other choices?

#
makd = function(x,k)
{
  n = length(x)
  if (k > n) stop("cant generate moving average")
  m = outer(1:k,0:(n-k),"+")
  x = matrix(x[m], nrow = k, ncol = (n - k + 1))
  return(as.vector(colMeans(x)))
}
mak(test, 11)


#### (e) How does your function behave if k = 1? What should it do? Fix it if necessary.

#should return the series itself
mak(test, 1)



## 5. Poisson process
### A Poisson process of rate lambda is a 
#random vector of times (T1,T2 ,T3 ,...) 
# where the interarrival times T1 ,T2−T1 ,T3−T2 ,... are 
# independent exponential random variables with paramerter lambda . 
# Note that this implies Ti+1>Ti .

#### a) Write a function with arguments lambda and M which generates a 
# Poisson process up until the time reaches M . 
# Using the rexp() family in R will be helpful.



#### b) Generate 10,000 of these series with lambda=5 and M=1 . 
# Record the lengths of each of the 10,000 vectors returned. 
#  Plot the vector lengths as a histogram. 
# Calculate their mean and variance. 
# How do you think the lengths are distributed? Explain.


## Because lambda = 5, and the mean&variance of Exponential are lambda. 
## So in this case(M = 1) the result can be expected.



