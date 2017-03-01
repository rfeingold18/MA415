source("xtable.r")
library(reshape2)
set.seed(1014)

preg <- matrix(c(NA, sample(20, 5)), ncol = 2, byrow = T)
colnames(preg) <- paste0("treatment", c("a", "b"))
rownames(preg) <- c("John Smith", "Jane Doe", "Mary Johnson")

xtable(preg, "preg-raw-1.tex", rownames = TRUE, align = "lrr")
xtable(t(preg), "preg-raw-2.tex", rownames = TRUE, align = "lrrr")

# Make tidy version

pregm <- melt(preg, id = "name")
names(pregm) <- c("name", "trt", "result")
pregm$trt <- gsub("treatment", "", pregm$trt)

xtable(pregm, "preg-tidy.tex")


##################

# The first table is difficult
# first to to the github site that Wickham sites in 
# the Tidy Data article  page 5
#
# With a little digging you find that Table 1 in "Tidy Data"
# is based on values produced by a function called preg.r
# download the function and run it
#  
# you'll note that the values for Table 1 are in a variable
# called preg.  And you should notice that preg is not a data.frame


source("preg.r")
library(tidyr)
library(stringr)

# make preg into a data.frame -- I call mine p

p <- as.data.frame(preg)

# the row names are not data
# get the row names, put them in a data.frame column called names

p <- cbind(p,names=row.names(p))

# now it looks like you have two columns with names -- but you don't
p

# so get rid of the column names that you can't use anyway,
# and rearrange the data.frame so it looks ok

row.names(p) <- NULL
p <- p[,c(3,1,2)]
p

# ok, now let's turn our table into attribute-key pairs

gather(p,treatment,value, -names)

# you can see that it's working but clumsy
# so rename the columns

colnames(p)
colnames(p) <- c("names", "a", "b")

# much better
gather(p, treatment, value,-names)

# so assign it to an appropriate name

tall <- gather(p, treatment, value,-names)
tall

# and use spread to see the table in Table1 form

spread(tall, treatment, value)

# and in Table2 form

spread(tall, names, value)





