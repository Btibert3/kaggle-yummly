// Apply the Constraints
CREATE CONSTRAINT ON (d:Dish) ASSERT d.id IS UNIQUE;
CREATE CONSTRAINT ON (i:Ingredient) ASSERT i.name IS UNIQUE;

// load the nodes
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/brock/github/kaggle-yummly/data/dummy-dish.csv" AS row
WITH row 
MERGE (d:Dish {id:row.id, cuisine:row.cuisine, set:row.set});

// load the ingredients
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/brock/github/kaggle-yummly/data/dummy-ing.csv" AS row
WITH row 
MERGE (ing:Ingredient {name:row.ingredient})
MERGE (d:Dish {id:row.id})
MERGE (ing) -[:PART_OF]-> (d);

// return the database
MATCH (n)
OPTIONAL MATCH (n)-[r]-()
RETURN n,r