options(stringsAsFactors=F)

## load the libraries
library(RNeo4j)
library(dplyr)
library(igraph)

## connect to the graph
graph = startGraph("http://localhost:7474/db/data/",
                   username = "neo4j",
                   password = "password")


## get the dishes in the test set
test_nodes = getNodes(graph, "MATCH (d:Dish {set:'test'}) RETURN d")
test_nodes_id = sapply(test_nodes, function(x) x$id)

#==============================================================================
## Submission 1:  The Most Common Cuisine
##                % = 19.028 or the all italian benchmark
#==============================================================================

## create the submission csv in the format id, cuisine
submission_1 = data.frame(id = test_nodes_id, cuisine = mode_cuisine$d.cuisine)
write.table(submission_1, 
            file="../submissions/submission1.csv", 
            sep=",", 
            row.names=F,
            quote=F)


#==============================================================================
## Submission XX:  The most similar dish, ignores ties, if nothing similar, guess italian
##  __NEVER SUBMITTED__ Takes WAYYYY To long in a serial format
#==============================================================================
 
## the jaccard similarity 
## http://www.lyonwj.com/twizzard-a-tweet-recommender-system-using-neo4j/
query = "
MATCH (d1:Dish {id:{test_id}}), (d2:Dish {set:'train'}) 
WHERE d1 <> d2
MATCH (d1)<--(mutual)-->(d2) 
WITH d1, d2, count(mutual) as intersect
MATCH (d1)<-[r1]-(ing1:Ingredient)
WITH d1, d2, intersect, collect(DISTINCT ing1) as coll1
MATCH (d2)<-[r2]-(ing2:Ingredient)
WITH d1, d2, intersect, coll1, collect(DISTINCT ing2) as coll2
WITH d1, d2, intersect, coll1, coll2, length(coll1 + filter(x IN coll2 WHERE NOT x IN coll1)) as union
// CREATE (d1)<-[:JACC_SIM {coef: (1.0*intersect/union)}]-(d2)
RETURN d1.id, d2.id as sim_id, d2.cuisine as sim_pred, (1.0*intersect/union) as coef
ORDER BY coef DESC
LIMIT 1
"


# ## for each, get the data
# start = Sys.time()
# for (TEST_ID in test_nodes_id) {
#   ## get the data
#   dat = cypher(graph, query, test_id = TEST_ID)
#   ## test if null
#   if (is.null(nrow(dat))) {
#     dat = bind_rows(d1.id = TEST_ID, sim_id = NA, sim_pred = "italian", coef = NA)
#   }
#   ## write the file
#   write.table(dat, file="../submissions/submission-2-tmp.csv", 
#               sep=",", 
#               row.names=F, 
#               na="", 
#               append = T, 
#               col.names = F)
#   cat("finished ", TEST_ID, " -- WHICH IS #: ",match(TEST_ID, test_nodes_id),  "\n")
# }
# end = Sys.time()



#==============================================================================
## Submission 2:  dataset for igraph, re-dedunant but as an example of speed for a "subgraph"
#==============================================================================

## trying to get graph OUT OF neo4j 
## issue might be that not all have cuisine using getNodes
## stack the data?  what is the better way to handle data where not all nodes may have a property?

## test nodes
query = "
MATCH (d:Dish {set:'train'})
RETURN ID(d) as g_id, d.id as dish_id, d.cuisine as cuisine, d.set as set
"
train_nodes = cypher(graph, query)

## train nodes
query = "
MATCH (d:Dish {set:'test'})
RETURN ID(d) as g_id, d.id as dish_id, d.set as set
"
test_nodes = cypher(graph, query)

## ingredient nodes
ing_nodes = cypher(graph, "MATCH (ing:Ingredient) RETURN ID(ing) as g_id, ing.name as name")


## stack the nodes -- get around the fact that getNodes might give us a hassle when 
## properties are missing
nodes = bind_rows(train_nodes, test_nodes)
nodes = bind_rows(nodes, ing_nodes)
rm(test_nodes, train_nodes)

## the edges
query = "
MATCH (d:Dish)<--(ing:Ingredient)
RETURN ID(ing) as src, ID(d) as dst
"
edges = cypher(graph, query)

## sanity check
length(unique(nodes$g_id)) == nrow(nodes)

## build the igraph object
g = graph_from_data_frame(edges, directed=T, vertices = nodes)

## get the vertices we want to compute similarity stats on
DISHS = which(!is.na(V(g)$dish_id))
vids = V(g)[DISHS]
rm(DISHS)
table(V(g)$set)

## run jaccard similarity on the inbound edges
## takes way too long
start = Sys.time()
jac_sim = similarity(g, vids=vids, mode = "in", loops=F, method="jaccard")
end = Sys.time()


