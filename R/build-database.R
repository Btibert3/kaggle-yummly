options(stringsAsFactors = F)

## load the libraries
library(jsonlite)
library(RNeo4j)
library(dplyr)


## load the data
train = fromJSON(unz("../data/train.json.zip", filename = "train.json"), simplifyDataFrame = F)
test = fromJSON(unz("../data/test.json.zip", filename = "test.json"), simplifyDataFrame = F)

## setup the data
train_dish = data.frame()
train_ing = data.frame()
test_dish = data.frame()
test_ing = data.frame()

## loop through the data for the training
for (i in 1:length(train)) {
  # subset the data
  x = train[[i]]
  # data frame for the training dish nodes
  x_dish = data.frame(id = x$id, cuisine = x$cuisine, set = "train")
  # data frame for the ingredients
  x_ing = data.frame(id = x$id, ingredient = x$ingredients)
  # append to the dataframes
  train_dish = bind_rows(train_dish, x_dish)
  train_ing = bind_rows(train_ing, x_ing)
  # clean up memory
  rm(x, x_dish, x_ing)
  cat("finished ", i, "of ", length(train), "\n")
} #endfor


## loop through the data for the training
for (i in 1:length(test)) {
  # subset the data
  x = test[[i]]
  # data frame for the training dish nodes
  x_dish = data.frame(id = x$id, set = "test")
  # data frame for the ingredients
  x_ing = data.frame(id = x$id, ingredient = x$ingredients)
  # append to the dataframes
  test_dish = bind_rows(test_dish, x_dish)
  test_ing = bind_rows(test_ing, x_ing)
  # clean up memory
  rm(x, x_dish, x_ing)
  cat("finished ", i, "of ", length(test), "\n")
} #endfor

## cleanup
rm(i)


## save the data just in case
save(test_dish, test_ing, train_dish, train_ing, file="../data/temp-data.Rdata")
write.table(test_dish, file="../data/test-dish.csv", sep=",", row.names=F)
write.table(train_dish, file="../data/train-dish.csv", sep=",", row.names=F)
write.table(test_ing, file="../data/test-ing.csv", sep=",", row.names=F)
write.table(train_ing, file="../data/train-ing.csv", sep=",", row.names=F)


## connect to the database -- will clear it out for this project
graph = startGraph("http://localhost:7474/db/data/",
                   username = "neo4j",
                   password = "password")
clear(graph, input = FALSE)

## what do we have
# dim(train_dish)
# dim(test_dish)
# dim(train_ing)
# dim(test_ing)
# head(train_dish)
# head(test_dish)

## 


## huh? -- how so many ingredients
# length(unique(test_ing$ingredient))
# length(unique(train_ing$ingredient))
# ings = unique(c(test_ing$ingredient, train_ing$ingredient))
# ings = sort(ings)
# head(ings)
# 
# ## obviously there is more that needs to be done on the ingredients
# ## amt/size, prep, ?
# 
# 
# ## combine the datasets


