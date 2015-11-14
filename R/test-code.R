###############################################################################
## A basic R program to read the nodes and process thru the API in parallel
###############################################################################

## options
options(stringsAsFactors=F)

## load the libraries
library(doMC)
library(RNeo4j)
library(dplyr)

## setup the parallel environment?
## https://cran.r-project.org/web/packages/doMC/vignettes/gettingstartedMC.pdf
registerDoMC(2)


## connect to the local neo database
graph = startGraph("http://localhost:7474/db/data/",
                   username = "neo4j",
                   password = "password")

## get the nodes we need to evaluate the model against
nodes = getNodes(graph, query="MATCH (n:Dish {set:'test'}) RETURN n")
node_ids = sapply(nodes, function(x) x$id)
node_ids[1]


###########################################
## Top 25 overlapping dishes to get mode or other selection criteria
## simple frequency based prediction


## testing
query = "
MATCH (d1:Dish {id:{NODE_ID}})<-[]-(ing:Ingredient)-[]->(d2:Dish {set:'train'})
RETURN d1.id, d2.id, d2.cuisine, count(ing) as overlap
ORDER BY overlap DESC
LIMIT 25
"

## function
top25 = function(graph, node_id, default_dish="italian") {
  query = "
  MATCH (d1:Dish {id:{node_id}})<-[]-(ing:Ingredient)-[]->(d2:Dish {set:'train'})
  RETURN d1.id, d2.id, d2.cuisine, count(ing) as overlap
  ORDER BY overlap DESC
  LIMIT 25
  "
  dat = cypher(graph, query, node_id = node_id)
  top_cuisine = tbl_df(dat) %>% 
    group_by(d2.cuisine) %>% 
    summarise(tot = length(d2.cuisine)) %>% 
    arrange(desc(tot)) %>% 
    top_n( 1, tot)
  test_dish = getOrCreateNode(graph, "Dish", id = node_id)
  updateProp(test_dish, top25_pred_cuisine = top_cuisine$d2.cuisine)
}


STOP!
  
  https://beckmw.wordpress.com/2014/01/21/a-brief-foray-into-parallel-processing-with-r/

## parallel over the function
parSapply(cl, nodes, top25, graph=graph, n)