
# vector, matrix, array  -- all same type
# list, frame -- don't all need to be in the same type
# keyboard shortcuts



x <- c("cl",3)
x
is.numeric(x)
typeof(x)
str(x)

y <- 10:-9
z <- as.character(y)
z
10:-9 -> hey

what <- 10:-9 -> gives

a <- 2:15
str(a)
is.atomic(a)
is.numeric(a)
is.integer(a)



set.seed(17)
a <- 100*runif(120) < 50
is.numeric(a)

mean(a)


x <- c(1,2,3, c(4,5,6))

# LISTS

x <- list(1,2,3, list(4,5,6))
x


# elements of any type

list_q <- list("here is my list", 5,6, "a", TRUE)

# lists can contain lists (recusive)

str(list_q)

is.list(list_q)

str(x)
########################################## attributes
a <- c(2,5,9)

attr(y, "first attribute") <- "this is a simple example"

str(y)

attr(y,"first attribute")

##############################################names

x <-  c(first=1,second=2,third=3)

x["first"]

y <- 10:14

names(y) <- c("ten","eleven", "twelve", "thirteen")
y

# better fix that

################################################ factors


x <- factor(c("high", "low", "low", "low", "high"))
class(x)
x
levels(x)

# matrix
# matrix, %*%, dim(), rbind(), cbind() solve()
x<- as.integer(10*runif(9))
x
A <- matrix(x,nrow = 3,byrow = TRUE)
A
b <- c(2, 3, 5)
b
B <- rbind(A,b)
B
C <- solve(A)
C
C%*%A

## [] operators
## NA

# positive integers
# neg 
# coersion of indices

### Data frame
# list of 

# for data
data("mtcars")

cars <- mtcars

dim(cars)

head(cars)


