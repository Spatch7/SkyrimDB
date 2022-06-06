--display merchants
SELECT merchantID, merchant_name, race, shop_name, gold, Locations.location_name AS location 
FROM Merchants 
INNER JOIN Locations ON Merchants.Locations_locationID = Locations.locationID;

--add merchant
INSERT INTO Merchants (merchant_name, race, shop_name, gold, Locations_locationID) VALUES (%s, %s, %s, %s, %s);

--location drop down used in add merchant
SELECT locationID, location_name FROM Locations;

--delete merchant
DELETE FROM Merchants WHERE merchantID= '%s';

--display items
SELECT itemID, item_name, class, damage, weight, value, Categories.category_name AS category, Enchantments.enchantment_name AS enchantment
FROM Items 
INNER JOIN Categories ON Items.Categories_categoryID = Categories.categoryID 
LEFT JOIN Enchantments ON Items.Enchantments_enchantmentID = Enchantments.enchantmentID;

--add item Null enchantment
INSERT INTO Items (item_name, class, damage, weight, value, Categories_categoryID) VALUES (%s, %s, %s, %s, %s, %s);

--add item with enchantment
INSERT INTO Items (item_name, class, damage, weight, value, Categories_categoryID, Enchantments_enchantmentID) VALUES (%s, %s, %s, %s, %s, %s, %s);

--category drop down
SELECT * FROM Categories;

--enchantment drop down
SELECT enchantmentID, enchantment_name FROM Enchantments;

--delete an item
DELETE FROM Items WHERE itemID = '%s';

--select item to edit
SELECT * FROM Items WHERE itemID = '%s';

--update item NULL enchantment
UPDATE Items 
SET Items.item_name = %s, Items.class = %s, Items.damage = %s, Items.weight = %s, Items.value = %s, Items.Categories_categoryID = %s, Items.Enchantments_enchantmentID = NULL
WHERE Items.itemID = %s;

--update item with enchantment
UPDATE Items 
SET Items.item_name = %s, Items.class = %s, Items.damage = %s, Items.weight = %s, Items.value = %s, Items.Categories_categoryID = %s, Items.Enchantments_enchantmentID = %s 
WHERE Items.itemID = %s;

--merchant drop down for merchants items selector
SELECT merchantID, merchant_name FROM Merchants;

--display selected merchants items
SELECT itemID, item_name, class, damage, weight, value, Categories.category_name AS category, Enchantments.enchantment_name AS enchantment 
FROM Merchants_Items 
INNER JOIN Items on Merchants_Items.Items_itemID = Items.itemID 
LEFT JOIN Categories ON Items.Categories_categoryID = Categories.categoryID 
LEFT JOIN Enchantments ON Items.Enchantments_enchantmentID = Enchantments.enchantmentID 
WHERE Merchants_Items.Merchants_merchantID = '%s';

--item drop down for add item to merchant
SELECT itemID, item_name FROM Items;

--add item to merchants_items
INSERT INTO Merchants_Items (Merchants_merchantID, Items_itemID) VALUES (%s, %s);

--delete item from merchants_items
DELETE FROM Merchants_Items WHERE Merchants_merchantID = %s AND Items_itemID = %s;

--display categories
SELECT * FROM Categories;

--add category
INSERT INTO Categories (category_name)
VALUES (:name_input);

--delete category
DELETE FROM Categories WHERE categoryID= '%s';

--selected category for merchants_categories
SELECT * FROM Categories WHERE categoryID = '%s';

--add a merchant to a category
INSERT INTO Merchants_Categories (Merchants_merchantID, Categories_categoryID) VALUES (%s, %s);

--delete merchant from category
DELETE FROM Merchants_Categories WHERE Merchants_merchantID = %s AND Categories_categoryID = %s;

--display merchants_categories
SELECT merchantID, merchant_name, race, shop_name, gold, Locations.location_name as Location 
FROM Merchants_Categories INNER JOIN Merchants on Merchants_Categories.Merchants_merchantID = Merchants.merchantID 
LEFT JOIN Locations ON Merchants.Locations_locationID = Locations.locationID 
WHERE Merchants_Categories.Categories_categoryID = '%s';

--display enchantments
SELECT * FROM Enchantments;

--add enchantment
INSERT INTO Enchantments (enchantment_name, school) VALUES (%s, %s);

--delete an enchantment
DELETE FROM Enchantments WHERE enchantmentID= '%s';

--display locations
SELECT * FROM Locations;

--add location
INSERT INTO Locations (location_name, hold, type) VALUES (%s, %s, %s);

--delete location
DELETE FROM Locations WHERE locationID= '%s';
