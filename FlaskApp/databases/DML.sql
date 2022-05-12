--display merchants
SELECT merchantID, merchant_name, race, shop_name AS shop, gold, Locations.location_name AS location
FROM Merchants
INNER JOIN Locations ON Merchants.Locations_locationID = Locations.locationID;

--location drop down used in add merchant
SELECT locationID, location_name FROM Locations;

--add merchant
INSERT INTO Merchants (merchant_name, race, shop_name, gold, Locations_locationID)
VALUES (:name_input, :race_input, :shop_input, :gold_input, :location_drop_down);

--display items
SELECT itemID, item_name, class, damage, weight, value, Categories.category_name AS category, Enchantments.enchantment_name AS enchantment
FROM Items
INNER JOIN Categories ON Items.Categories_categoryID = Categories.categoryID
LEFT JOIN Enchantments ON Items.Enchantments_enchantmentID = Enchantments.enchantmentID;

--category drop down used in add item
SELECT categoryID, category_name FROM Categories;

--enchantment drop down used in add item
SELECT enchantmentID, enchantment_name FROM Enchantments;

--add item
INSERT INTO Items (item_name, class, damage, weight, value, Categories_categoryID, Enchantments_enchantmentID)
VALUES (:name_input, :class_input, :damage_input, :weight_input, :value_input, :cat_dropdown, :ench_dropdown);

--remove enchantment (NULLable relationship)


--display locations
SELECT * FROM Locations;

--add location
INSERT INTO Locations (location_name, hold, type)
VALUES (:name_input, :hold_input, :type_input);

--display categories
SELECT * FROM Categories;

--add category
INSERT INTO Categories (category_name)
VALUES (:name_input);

--display Merchant_Items


--add item to merchant


--merchant drop down used in delete item from inventory
SELECT merchantID, merchant_name FROM Merchants;

/*--item drop down used in delete item from inventory
SELECT itemID, item_name FROM Items WHERE */

--delete item from merchant inventory
DELETE FROM Merchant_Items 
WHERE Merchants_merchantID = :drop_down_merch AND Items_itemID = :drop_down_item;

--display Merchant_category

--add category to merchant

