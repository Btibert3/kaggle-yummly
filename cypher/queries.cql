// Find the example dish from the competition
MATCH (x:Dish {id:'24717'})-[r]-(y)
RETURN x,r,y


// 