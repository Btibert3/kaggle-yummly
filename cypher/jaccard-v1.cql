
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
CREATE (d1)<-[:JACC_SIM {coef: (1.0*intersect/union)}]-(d2);
