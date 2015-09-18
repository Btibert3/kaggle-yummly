// Find the example dish from the competition
MATCH (x:Dish {id:'24717'})-[r]-(y)
RETURN x,r,y


// Top 25 dishes, but there are only 20 in the training set
MATCH (d:Dish {set:'train'})
WITH d
RETURN d.cuisine, COUNT(d) as total
ORDER BY total DESC
LIMIT 25


// ensure test sets exist
MATCH (d:Dish {set:'test'})
RETURN COUNT(d)


// most popular ingredients in training set
MATCH (i:Ingredient)-[r]->(d:Dish {set:'train'})
RETURN i, count(r) as total
ORDER BY total DESC
LIMIT 25


// Count unique ingredients -- are the dupes errors?
MATCH (i:Ingredient)-[r]->(d:Dish {set:'train'})
WITH i,r, d
RETURN i, count(DISTINCT d) as total
ORDER BY total DESC
LIMIT 25


// where is salt used twice
MATCH (i:Ingredient {name:'salt'})-[r]->(d:Dish {set:'train'})
WITH i, count(r) as tot, d
RETURN d, tot
ORDER BY tot DESC
LIMIT 1

// Get around the data by using MERGE on the relationship creation


// Top 100 dishes that share ingredients with the example dish
MATCH (d1:Dish {id:'24717'})<-[]-(ing:Ingredient)-[]->(d2:Dish {set:'train'})
WITH d1, d2, count(ing) as overlap
RETURN d1, d2, overlap
ORDER BY overlap DESC
LIMIT 100
