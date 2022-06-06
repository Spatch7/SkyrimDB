/*Andrew Olness
Noah Calhoun
Group 75*/

SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;

CREATE OR REPLACE TABLE Categories (
    categoryID int NOT NULL AUTO_INCREMENT,
    category_name varchar(45) NOT NULL,
    PRIMARY KEY (categoryID)
);

CREATE OR REPLACE TABLE Enchantments (
    enchantmentID int NOT NULL AUTO_INCREMENT,
    enchantment_name varchar(45) NOT NULL,
    school varchar(45),
    PRIMARY KEY (enchantmentID)
);

CREATE OR REPLACE TABLE Items (
    itemID int NOT NULL AUTO_INCREMENT,
    item_name varchar(45) NOT NULL,
    class varchar(45) NOT NULL,
    damage int,
    weight int NOT NULL,
    value int NOT NULL,
    Categories_categoryID int NOT NULL,
    Enchantments_enchantmentID int,
    PRIMARY KEY (itemID),
    FOREIGN KEY (Categories_categoryID) REFERENCES Categories (categoryID),
    FOREIGN KEY (Enchantments_enchantmentID) REFERENCES Enchantments (enchantmentID)
);

CREATE OR REPLACE TABLE Locations (
    locationID int NOT NULL AUTO_INCREMENT,
    location_name varchar(45) NOT NULL UNIQUE,
    hold varchar(45) NOT NULL,
    type varchar(45) NOT NULL,
    PRIMARY KEY (locationID)
);

CREATE OR REPLACE TABLE Merchants (
    merchantID int NOT NULL AUTO_INCREMENT,
    merchant_name varchar(45) NOT NULL UNIQUE,
    race varchar(45) NOT NULL,
    shop_name varchar(45),
    gold int NOT NULL,
    Locations_locationID int NOT NULL,
    PRIMARY KEY (merchantID),
    FOREIGN KEY (Locations_locationID) REFERENCES Locations (locationID)
);

CREATE OR REPLACE TABLE Merchants_Categories (
    Merchants_Category_ID int NOT NULL AUTO_INCREMENT,
    Merchants_merchantID int NOT NULL,
    Categories_categoryID int NOT NULL,
    PRIMARY KEY (Merchants_Category_ID),
    FOREIGN KEY (Merchants_merchantID) REFERENCES Merchants (merchantID) ON DELETE CASCADE,
    FOREIGN KEY (Categories_categoryID) REFERENCES Categories (categoryID) ON DELETE CASCADE
);

CREATE OR REPLACE TABLE Merchants_Items (
    Merchants_Items_ID int NOT NULL AUTO_INCREMENT,
    Merchants_merchantID int NOT NULL,
    Items_itemID int NOT NULL,
    PRIMARY KEY (Merchants_Items_ID),
    FOREIGN KEY (Merchants_merchantID) REFERENCES Merchants (merchantID) ON DELETE CASCADE,
    FOREIGN KEY (Items_itemID) REFERENCES Items (itemID) ON DELETE CASCADE
);

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

INSERT INTO Locations (location_name, hold, type)
VALUES ('Dawnstar', 'The Pale', 'City'),
('Falkreath', 'Falkreath Hold', 'City'),
('Markarth', 'The Reach', 'City'),
('Morthal', 'Hjaalmarch', 'City'),
('Riften', 'The Rift', 'City'),
('Solitude', 'Haafingar', 'City'),
('Whiterun', 'Whiterun Hold', 'City'),
('Windhelm', 'Eastmarch', 'City'),
('Winterhold', 'Winterhold', 'City'),
('The Ragged Flagon', 'The Rift', 'Guild Headquarters'),
('Ivarstead', 'The Rift', 'Town'),
('Riverwood', 'Whiterun Hold', 'Town'),
('Rorikstead', 'Whiterun Hold', 'Town'),
('Narzulbur', 'Eastmarch', 'Orc Stronghold'),
('Dragons Bridge', 'Haafingar', 'Town'),
('Mor Khazgur', 'Haafingar', 'Orc Stronghold'),
('Dushnikh Yal', 'The Reach', 'Orc Stronghold'),
("Shor's Stone", 'The Rift', 'Town'),
('College of Winterhold', 'Winterhold', 'Guild Headquarters');

INSERT INTO Merchants (merchant_name, race, shop_name, gold, Locations_locationID)
VALUES ('Nurelion', 'Altmer', 'The White Phial', 500, (SELECT locationID FROM Locations WHERE location_name = 'Windhelm')),
('Oengul War-Anvil', 'Nord', 'Blacksmith Quarters', 1000, (SELECT locationID FROM Locations WHERE location_name = 'Windhelm')),
('Lod', 'Nord', "Lod's House", 1000, (SELECT locationID FROM Locations WHERE location_name = 'Falkreath')),
('Gulum-Ei', 'Argonian', 'The Winking Skeever', 2500, (SELECT locationID FROM Locations WHERE location_name = 'Solitude')),
('Sybille Stentor', 'Breton', 'Blue Palace', 500, (SELECT locationID FROM Locations WHERE location_name = 'Solitude')),
('Faida', 'Nord', 'Four Shields Tavern', 100, (SELECT locationID FROM Locations WHERE location_name = 'Dragons Bridge')),
('Lami', 'Nord', "Thaumaturgist's Hut", 1000, (SELECT locationID FROM Locations WHERE location_name = 'Morthal')),
('Frida', 'Nord', 'The Morta and Pestle', 500, (SELECT locationID FROM Locations WHERE location_name = 'Dawnstar')),
('Calcelmo', 'Altmer', 'Understone Keep', 500, (SELECT locationID FROM Locations WHERE location_name = 'Markarth')),
('Balimund', 'Nord', 'The Scorched Hammer', 1000, (SELECT locationID FROM Locations WHERE location_name = 'Riften')),
('Wilhelm', 'Nord', 'Vilemyr Inn', 100, (SELECT locationID FROM Locations WHERE location_name = 'Ivarstead')),
('Nelacar', 'Altmer', 'The Frozen Hearth', 500, (SELECT locationID FROM Locations WHERE location_name = 'Winterhold'));

INSERT INTO Categories (category_name)
VALUES ('Alchemist'),
('Blacksmith'),
('Fence'),
('Spells'),
('General'),
('Armorer'),
('Food');

INSERT INTO Enchantments (enchantment_name, school)
VALUES ('Absorb Health', 'Destruction'),
('Absorb Magicka', 'Destruction'),
('Absorb Stamina', 'Destruction'),
('Banish', 'Conjuration'),
('Chaos Damage DR',	'Destruction'),
('Fear', 'Illusion'),
('Fiery Soul Trap', 'Conjuration'),
('Fire Damage', 'Destruction'),
('Frost Damage', 'Destruction'),
("Huntsman's Prowess", NULL),
('Magicka Damage', 'Destruction'),
('Notched Pickaxe', NULL),
('Paralyze', 'Alteration'),
('Shock Damage', 'Destruction'),
('Silent Moons Enchant', 'Destruction'),
('Soul Trap', 'Conjuration'),
('Stamina Damage', 'Destruction'),
('Turn Undead', 'Restoration');

INSERT INTO Items (item_name, class, damage, weight, value, Categories_categoryID, Enchantments_enchantmentID)
VALUES ('Iron Dagger', 'Dagger', 5, 1, 10, (SELECT categoryID FROM Categories WHERE category_name = 'Blacksmith'), NULL),
('Dwarven Dagger', 'Dagger', 7, 3.5, 55, (SELECT categoryID FROM  Categories WHERE category_name = 'Blacksmith'), (SELECT enchantmentID FROM Enchantments WHERE enchantment_name = 'Fire Damage')),
('Elven Dagger', 'Dagger', 8, 4, 95, (SELECT categoryID FROM Categories WHERE category_name = 'Blacksmith'), (SELECT enchantmentID FROM Enchantments WHERE enchantment_name = 'Paralyze')),
('Iron Mace', 'Mace', 9, 13, 35, (SELECT categoryID FROM Categories WHERE category_name = 'Blacksmith'), NULL),
('Steel Mace', 'Mace', 10, 14, 65, (SELECT categoryID FROM Categories WHERE category_name = 'Blacksmith'), (SELECT enchantmentID FROM Enchantments WHERE enchantment_name = 'Stamina Damage')),('Scimitar','Sword', 11, 10, 5, (SELECT categoryID From Categories WHERE category_name = 'Blacksmith'), NULL),
('Iron Sword','Sword', 7, 9, 25, (SELECT categoryID From Categories WHERE category_name = 'Blacksmith'), NULL),
('Steel Sword','Sword', 8, 10, 45, (SELECT categoryID From Categories WHERE category_name = 'Blacksmith'), NULL),
('Leather Helmet','Helmet', 12, 2, 60, (SELECT categoryID From Categories WHERE category_name = 'Armorer'), NULL),
('Elven Helmet','Helmet', 14, 1, 110, (SELECT categoryID From Categories WHERE category_name = 'Armorer'), NULL),
('Shrouded Cowl','Hood', 13, 2, 667, (SELECT categoryID From Categories WHERE category_name = 'Armorer'), NULL),
('Shrouded Armor','Cuirass', 29, 7, 373, (SELECT categoryID From Categories WHERE category_name = 'Armorer'), NULL),
('Ebony Armor','Cuirass', 43, 28, 1500, (SELECT categoryID From Categories WHERE category_name = 'Armorer'), NULL);

INSERT INTO Merchants_Categories (Merchants_merchantID, Categories_categoryID)
VALUES ((SELECT merchantID FROM Merchants WHERE merchant_name = 'Nurelion'), (SELECT categoryID FROM Categories WHERE category_name = 'Alchemist')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Oengul War-Anvil'), (SELECT categoryID FROM Categories WHERE category_name = 'Blacksmith')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Lod'), (SELECT categoryID FROM Categories WHERE category_name = 'Blacksmith')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Gulum-Ei'), (SELECT categoryID FROM Categories WHERE category_name = 'General')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Gulum-EI'), (SELECT categoryID FROM Categories WHERE category_name = 'Food')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Sybille Stentor'), (SELECT categoryID FROM Categories WHERE category_name = 'Spells')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Faida'), (SELECT categoryID FROM Categories WHERE category_name = 'Food')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Lami'), (SELECT categoryID FROM Categories WHERE category_name = 'Alchemist')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Frida'), (SELECT categoryID FROM Categories WHERE category_name = 'Alchemist')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Calcelmo'), (SELECT categoryID FROM Categories WHERE category_name = 'Spells')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Balimund'), (SELECT categoryID FROM Categories WHERE category_name = 'Blacksmith')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Wilhelm'), (SELECT categoryID FROM Categories WHERE category_name = 'Food')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Nelacar'), (SELECT categoryID FROM Categories WHERE category_name = 'Spells'));


INSERT INTO Merchants_Items (Merchants_merchantID, Items_itemID)
VALUES ((SELECT merchantID FROM Merchants WHERE merchant_name = 'Oengul War-Anvil'), (SELECT itemID FROM Items WHERE item_name = 'Iron Dagger')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Oengul War-Anvil'), (SELECT itemID FROM Items WHERE item_name = 'Dwarven Dagger')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Oengul War-Anvil'), (SELECT itemID FROM Items WHERE item_name = 'Elven Dagger')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Oengul War-Anvil'), (SELECT itemID FROM Items WHERE item_name = 'Iron Mace')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Oengul War-Anvil'), (SELECT itemID FROM Items WHERE item_name = 'Steel Mace')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Oengul War-Anvil'), (SELECT itemID FROM Items WHERE item_name = 'Scimitar')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Lod'), (SELECT itemID FROM Items WHERE item_name = 'Leather Helmet')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Lod'), (SELECT itemID FROM Items WHERE item_name = 'Elven Helmet')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Lod'), (SELECT itemID FROM Items WHERE item_name = 'Shrouded Cowl')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Lod'), (SELECT itemID FROM Items WHERE item_name = 'Shrouded Armor')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Balimund'), (SELECT itemID FROM Items WHERE item_name = 'Ebony Armor')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Balimund'), (SELECT itemID FROM Items WHERE item_name = 'Shrouded Cowl')),
((SELECT merchantID FROM Merchants WHERE merchant_name = 'Balimund'), (SELECT itemID FROM Items WHERE item_name = 'Shrouded Armor'));