// Apply the Constraints
CREATE CONSTRAINT ON (d:Dish) ASSERT d.id IS UNIQUE;
CREATE CONSTRAINT ON (i:Ingredient) ASSERT i.name IS UNIQUE;