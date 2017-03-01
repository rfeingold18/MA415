# Problem 1
# a. Check if A^3 = 0
A <- matrix(data =c(1,5,-2,1,2,-1,3,6,-3), nrow = 3, ncol = 3)
A
A%*%A%*%A
# b. Replace the third column of A by the sum of the second and third columns.
A[,3] <- A[,2]+A[,3]
A

# Problem 2. Create Matrix B and calculate B^TB
B <- matrix(data=c(10,-10,10), byrow = TRUE, nrow = 15, ncol = 3)
Prod <- t(B)%*%B
Prod

# Problem 3. Create Matrix matE with all entries equal to 0
matE <- matrix(0, nrow = 6, ncol = 6)
row(matE)
col(matE)
(abs(row(matE)-col(matE))==1)*1

# Problem 4. Use function outer to create a patterned matrix
s <-  0:4
outer(s,s,"+")

# Problem 5. Create large patterned matrices
#a. 
s <-  0:4
outer(s,s,"+")%%5
#b. 
a <- 0:9
outer(a,a,"+")%%10
#c. 
outer(0:8,0:8,"-")%%9

# Problem 6. Solve system of linear equations
y <- matrix(c(7,-1,-3,5,17),c(5,1), byrow = TRUE)
A <- matrix(0,nrow = 5,ncol = 5)
A <- abs(row(A)-col(A))+1
x <- solve(A,y)
x

# Problem 7. Create Matrix of random intergers from from 1,2,...,10.Matrix is 6 x 10.
set.seed(75)
aMat <- matrix( sample(10, size=60, replace=T), nr=6)
aMat
# a. Find numbers of entities in each row which are greater than 4.
cond <- (aMat>4) *1
rowSums(cond)
# b. Which rows contain exactly two occurrences of the number seven?
cond <- (aMat==7) *1
x <- rowSums(cond)
which(x==2)
# c. Find those pairs of columns whose total (over both columns) is greater than 75.
ColSumsaMat <- colSums(aMat)
ColSumsaMat
t <- outer(ColSumsaMat,ColSumsaMat,'+') #forms matrix of two column sums
t1 <- t>75 # filter for pairs whose sum >75 (Logicals)
t1 <- t1*1 # filtered as Binaries
t1 <- upper.tri(t1,diag=TRUE)*1*t1 #eliminate the repeated answers in the lower triangle
t1 <- upper.tri(t1,diag=TRUE)&t1  #eliminates repeated answers in logical matrix using logical AND operator
t1

which(t1,arr.ind=TRUE, useNames = TRUE)

# Problem 8. Calculate

options(digits = 2)
# a. Need to seperate the sums: sum[(i=1:20) i^4 * sum[(i=1:5) (i+3)^-1]] #calculate the inner sum first
s1 <- sum(1/4:8)
s1 * sum((1:20)^4) #multple prvious sum by the outer sum

# b. Need to make a  matrix by forming 2 vectors  and using outer(). Make the denominator first.
outer(1:20,1:5,"*") # matrix of ij products
denom <- outer(1:20,1:5,"*") +3
denom
numer <- (1:20)^4
numer
sum(numer/denom)

# c. Similiar to b, need a 10x10 denom matrix and a length=10 numerator
denom <- outer(1:10, 1:10,"*") +3
numer <- (1:10)^4
t <- numer/denom
t
# sum either upper or lower triangle, try out both, use lower 
sum(lower.tri(t,dia=TRUE)*t)
