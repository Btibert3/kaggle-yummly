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

## on the training set, take 10% of rows and make them eval for the model tuning
ROWS = sample(x = 1:nrow(train_dish), size = .1*nrow(train_dish), replace = F)
train_dish$set[ROWS] = "eval"
rm(ROWS)


## save out the data
save(test_dish, test_ing, train_dish, train_ing, file="../data/temp-data.Rdata")
write.table(test_dish, file="../data/test-dish.csv", sep=",", row.names=F)
write.table(train_dish, file="../data/train-dish.csv", sep=",", row.names=F)
write.table(test_ing, file="../data/test-ing.csv", sep=",", row.names=F)
write.table(train_ing, file="../data/train-ing.csv", sep=",", row.names=F)


## save out a few rows of data from training to code models quickly
IDS = sample(train_dish$id, size = 25, replace=F)
dummy_dish = subset(train_dish, id %in% IDS)
dummy_ing = subset(train_ing, id %in% dummy_dish$id)
rm(IDS)

## mirror the data train/test for the model, no eval set b/c small data
ROWS = sample(1:25, 5, replace=F)
dummy_dish$set = "train"
dummy_dish$set[ROWS] = "test"
rm(ROWS)

## save the data for use
write.table(dummy_dish, file="../data/dummy-dish.csv", sep=",", row.names=F)
write.table(dummy_ing, file="../data/dummy-ing.csv", sep=",", row.names=F)


## connect to the database -- will clear it out for this project
graph = startGraph("http://localhost:7474/db/data/",
                   username = "neo4j",
                   password = "password")
clear(graph, input = FALSE)

