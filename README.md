# About

https://www.kaggle.com/c/whats-cooking

## The description

Use recipe ingredients to predict the category of cuisine

Picture yourself strolling through your local, open-air market... What do you see? What do you smell? What will you make for dinner tonight?

If you're in Northern California, you'll be walking past the inevitable bushels of leafy greens, spiked with dark purple kale and the bright pinks and yellows of chard. Across the world in South Korea, mounds of bright red kimchi greet you, while the smell of the sea draws your attention to squids squirming nearby. India’s market is perhaps the most colorful, awash in the rich hues and aromas of dozens of spices: turmeric, star anise, poppy seeds, and garam masala as far as the eye can see.

Some of our strongest geographic and cultural associations are tied to a region's local foods. This playground competitions asks you to predict the category of a dish's cuisine given a list of its ingredients. 

Acknowledgements

We want to thank Yummly for providing this unique dataset. Kaggle is hosting this playground competition for fun and practice.

## Populate Neo4j

1.  Make sure that `neo4j` is running  
2.  Run the script `R/build-database.R` which reads the files and creates CSVs and wipes out any data that you have in `Neo4j` 
3.  Run the two shell commands found in `cypher/create-db.sh`  

This will add constraints, and the data to the database. 

#### Data Considerations  

1.  It looks like there are some duplicate data.  For example, look at dish id `26165` in the training set.  Perhaps I parsed the files incorrectly, but it appears to be duplicate data.  Luckily we can use `MERGE` within `neo4j` to create unique nodes and edges.

## Scripts

1. `cypher/queries.cql` contains `cypher` code to query the database.  
2. `R/explore-yummly.R` does the same within `R`

