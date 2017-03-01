# Reproduce the table transformation Wickham describes on pg 1-6 (tables 1-5) use dplyr and tidyr

library(dplyr)
library(tidyr)

# table 1

person <- c("John Smith", "Jane Doe", "Mary Johnson")
treatment <- c("a", "b")
results <- c(NA, 16, 3, 2, 11, 1)
table1 <- as.data.frame(matrix(results, 3, 2, byrow = FALSE))
table1 <- data.frame(table1, row.names = person)
names(table1)[1] <- paste("treatmenta")
names(table1)[2] <- paste("treatmentb")
table1

# table 2

table2 <- t(table1)
table2 

# table 3

table3 <- gather(table1, treatment, results)
table3


# table 4

religion <- c("Agnostic", "Atheist", "Buddhist", "Catholic", "Don't know/ refused", "Evangelist Prot", "Hindu", "Historically Black Prot", "Jehovah's Witness", "Jewish")
income <- c("", "$10-20k", "$20-30k", "$30-40k", "$40-50k", "$50-75k") 
data <- c(27, 12, 27, 418, 15, 575, 1, 228, 20, 19, 34, 27, 21, 617, 14, 869, 9, 244, 27, 19, 60, 37, 30, 732, 15, 1064, 7, 236, 24, 25, 81, 52, 34, 670, 11, 982, 9, 238, 24, 25, 76, 35, 33, 638, 10, 881, 11, 197, 21, 30, 137, 70, 58, 1116, 35, 1468, 34, 223, 30, 95) 
table4 <- as.data.frame(matrix(data, 10, 6, byrow = FALSE))
table4 <- data.frame(table4, row.names = religion)
names(table4)[1] <- paste("<$10k")
names(table4)[2] <- paste("$10-20k")
names(table4)[3] <- paste("$20-30k")
names(table4)[4] <- paste("$30-40k")
names(table4)[5] <- paste("$40-50k")
names(table4)[6] <- paste("$50-75k")
table4

# table 5 Melting

# a. raw data

row <- c("A", "B", "C")
col_a <- c(1,2,3)
col_b <- c(4,5,6)
col_c <- c(7,8,9)
values <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)

table5a <- as.data.frame(matrix(values, 3, 3, byrow = FALSE))
table5a
names(table5a)[1] <- paste ("a")
names(table5a)[2] <- paste ("b")
names(table5a)[3] <- paste ("c")

# b. molten data

table5b <- gather(table5a, row)
table5b

# table 6 

table6 <- gather(table4, religion )
table6

# can't get first column of the row names in the transformed matrices!- eek sorry! i will look more over the weekend