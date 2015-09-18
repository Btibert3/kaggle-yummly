// test dish
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/brock/github/kaggle-yummly/data/test-dish.csv" AS row
WITH row 
MERGE (d:Dish {id:row.id, set:row.set});


// train dish
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/brock/github/kaggle-yummly/data/train-dish.csv" AS row
WITH row 
MERGE (d:Dish {id:row.id, cuisine:row.cuisine, set:row.set});


// test ingredients
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/brock/github/kaggle-yummly/data/test-ing.csv" AS row
WITH row 
MERGE (ing:Ingredient {name:row.ingredient})
MERGE (d:Dish {id:row.id})
MERGE (ing) -[:PART_OF]-> (d);


// train ingredients
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/brock/github/kaggle-yummly/data/train-ing.csv" AS row
WITH row 
MERGE (ing:Ingredient {name:row.ingredient})
MERGE (d:Dish {id:row.id})
MERGE (ing) -[:PART_OF]-> (d);