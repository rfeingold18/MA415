
## This is a demonstration  

mat <- outer(c(1:6),c(1:4))
mat
colnames(mat) <- c("q","w","o","p")
mat
thelist <- list(mat, c(pi, log(2), 0.5), data.frame(a=c(1,5,7),b=c(4,6,8)))
thelist
matrixlist <- list(mat, outer(c(1:4),c(1:4)))
matrixlist
squarelist <- list(outer(c(1:6),c(1:6),"^"), outer(c(1:4),c(1:4)))
squarelist
### apply: must be used on a matrix
# If you use this func on df, it would
# be converted to a matrix.
apply(mat, 1, sum)
apply(mat, 2, sum)

colSums(mat)
rowSums(mat)

apply(mat, 1, function(x) sum(x^2+1))
sum(c(1,2,3,4)^2 + 1)


### lapply: used for a list. Within the list, anything you want.
thelist
lapply(thelist, sum)
lapply(thelist, colnames)

func1 <- function(x) sum(x^2+1)
lapply(matrixlist, function(x) apply(x, 1, func1))
lapply(squarelist, t)


### sapply, exactly the same as lapply, but returns vector
# (only when the output is a number)
sapply(thelist, sum)
sapply(thelist, colnames)

func1 <- function(x) sum(x^2+1)
sapply(matrixlist, function(x) apply(x, 1, func1))
sapply(squarelist, t)


### mapply, apply functions to elements of multiple list at the same time
sumnrow2 <- function(x, y) nrow(x) + nrow(y)
mapply(sumnrow2, matrixlist, squarelist)

la <- list(c(1:10),c(2:11), 1)
lb <- list(c(1:5), c(2:6), 2)
lc <- list(4, 5, 3)

la2 <- list(c(1:10),c(2:11))
lb2 <- list(c(1:5),c(2:6))
lc2 <- list(4,5)

mapply(sum, la, lb, lc) # sum of first element in three lists
mapply(cbind, la, lb, lc)
mapply(cbind, la2, lb2, lc2) # because elements in the same list always have the same shape


### tapply
# use tapply when you want to apply a function to subsets of
# a vector and the subsets are defined by some other vector, usually a factor
vec <- c(20:1); vec
index <- c(rep(1,10),rep(0,10)); index
tapply(vec, index, sum)

index2 <- c(rep("a",5),rep("b",5),rep("third",5),rep("4th",5)); index2
tapply(vec, index2, mean)

### rapply
# For when you want to apply a function to each element of a nested list
# structure, recursively. 

myfunc <- function(x){
  if (is.character(x)){
    return(paste(x,"!",sep=""))
  } else { 
    return(x + 1)}
}

thelist2 <- list(a = list(a1 = "Boo", b1 = 2, c1 = "Elk"), 
                 b = 3, c = "Yikes", 
                 d = list(a2 = 1, b2 = list(a3 = "Hey", b3 = 5)))

rapply(thelist2, myfunc)
rapply(thelist, myfunc)



### eapply
# apply a function over values in an Envrionment
######  MAKE SURE YOU DO THIS (use the broom!)
# Clear the global environment (workspace)
a <- 1
b <- 3
c <- -5
eapply(globalenv(), FUN='sqrt')

