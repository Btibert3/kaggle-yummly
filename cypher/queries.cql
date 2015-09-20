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


// Top 25 test dishes similar , on volume overlap, to the example dish
MATCH (d1:Dish {id:'24717'})<-[]-(ing:Ingredient)-[]->(d2:Dish {set:'test'})
WITH d1, d2, count(ing) as overlap
RETURN d1, d2, overlap
ORDER BY overlap DESC
LIMIT 25


// jaccard similarity
// http://www.lyonwj.com/twizzard-a-tweet-recommender-system-using-neo4j/
MATCH (d1:Dish {set:'train'}), (d2:Dish {set:'test'}) 
WHERE d1 <> d2
MATCH (d1)<--(mutual)-->(d2) 
WITH d1, d2, count(mutual) as intersect
MATCH (d1)<-[r1]-(ing1:Ingredient)
WITH d1, d2, intersect, collect(DISTINCT ing1) as coll1
MATCH (d2)<-[r2]-(ing2:Ingredient)
WITH d1, d2, intersect, coll1, collect(DISTINCT ing2) as coll2
WITH d1, d2, intersect, coll1, coll2, length(coll1 + filter(x IN coll2 WHERE NOT x IN coll1)) as union
CREATE (d1)<-[:JACC_SIM {coef: (1.0*intersect/union)}]-(d2)








