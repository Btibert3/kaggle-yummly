# create the constraints
~/neo4j-community-2.2.0/bin/neo4j-shell -file ~/github/kaggle-yummly/cypher/constraints.cql 

# create the database
~/neo4j-community-2.2.0/bin/neo4j-shell -file ~/github/kaggle-yummly/cypher/import-yummly.cql 

# apply the first version of the jaccard similarity
# how fast should this run?
# ~/neo4j-community-2.2.0/bin/neo4j-shell -file ~/github/kaggle-yummly/cypher/jaccard-v1.cql 