options(stringsAsFactors=F)

## load the data
library(jsonlite)
train = fromJSON("../data/train.json", simplifyDataFrame = F)
length(train)
train[[1]]


## neo4j -- feed it lists, but in transactions?
# ?RNeo4j::createNode 
# https://github.com/nicolewhite/RNeo4j