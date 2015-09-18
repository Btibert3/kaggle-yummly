options(stringsAsFactors=F)

## explore the yummly database
load("../data/temp-data.Rdata")

## load the libraries
library(dplyr)

## popular ingredients
tbl_df(train_ing) %>% 
  group_by(ingredient) %>% 
  summarise(total = length(unique(id))) %>% 
  arrange(desc(total)) %>% 
  head(25)

## it looks like some dishes are there twice?
## if use CREATE for the relationship, these are there
## remove them with the MERGE for the relationship
subset(train_ing, id == '26165')
