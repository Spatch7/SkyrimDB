from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
from flask import request
import os


app = Flask(__name__)
# DB connection info
app.config['MYSQL_HOST'] = 'classmysql.engr.oregonstate.edu'
app.config['MYSQL_USER'] = 'cs340_calhounn'
app.config['MYSQL_PASSWORD'] = '3792' #last 4 of onid
app.config['MYSQL_DB'] = 'cs340_calhounn'
app.config['MYSQL_CURSORCLASS'] = "DictCursor"


mysql = MySQL(app)

# Routes
# home page
@app.route('/')
def home():
    return redirect('/Merchants')   # render_template("Merchants.j2")

@app.route('/Merchants', methods=['POST', 'GET'])
def merchants():
    if request.method == 'POST':
        # if press user adds a new merchant, 
        # obtain stats and update page with new merchant
        if request.form.get('Add_Merchant'):
            merchant_name = request.form['merchant_name']
            race = request.form['race']
            shop_name = request.form['shop_name']
            gold = request.form['gold']
            Locations_locationID = request.form['location']    

            query = 'INSERT INTO Merchants (merchant_name, race, shop_name, gold, Locations_locationID) VALUES (%s, %s, %s, %s, %s);'    
            cur = mysql.connection.cursor()
            cur.execute(query, (merchant_name, race, shop_name, gold, Locations_locationID))
            mysql.connection.commit()
        
        return redirect('/Merchants')

    # display merchants
    if request.method == 'GET':
        query = 'Select * from Merchants'
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        
        query2 = 'SELECT locationID, location_name FROM Locations;'
        cur = mysql.connection.cursor()
        cur.execute(query2)
        location_data = cur.fetchall()
        
        return render_template('Merchants.j2', data=data, location_data=location_data)

@app.route('/Merchants_delete/<int:id>')
def delete_merchant(id):
    """Receives merchant id, deletes a merchant from the Merchant table"""
    query = "DELETE FROM Merchants WHERE merchantID= '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (id,))
    mysql.connection.commit()
    # Return to merchants page after removing merchant
    return redirect("/Merchants")


@app.route('/Items', methods = ['POST', 'GET'])
def items():
    # add an item
    if request.method == 'POST':
        if request.form.get('Add_Item'):
            item_name = request.form['item_name']
            item_class = request.form['class']
            damage = request.form['damage']
            weight = request.form['weight']
            value = request.form['value']
            category = request.form['Categories_categoryID']
            enchantment = request.form['Enchantments_enchantmentID']

            # if enchantment is Null
            if enchantment == '0':
                query = 'INSERT INTO Items (item_name, class, damage, weight, value, Categories_categoryID) VALUES (%s, %s, %s, %s, %s, %s);'
                cur = mysql.connection.cursor()
                cur.execute(query, (item_name, item_class, damage, weight, value, category))
                mysql.connection.commit()
            # enchantment not null
            else:
                query = 'INSERT INTO Items (item_name, class, damage, weight, value, Categories_categoryID, Enchantments_enchantmentID) VALUES (%s, %s, %s, %s, %s, %s, %s);'
                cur = mysql.connection.cursor()
                cur.execute(query, (item_name, item_class, damage, weight, value, category, enchantment))
                mysql.connection.commit()

            return redirect('/Items')

    # display items
    if request.method == 'GET':
        query = 'SELECT itemID, item_name, class, damage, weight, value, Categories.category_name AS category, Enchantments.enchantment_name AS enchantment FROM Items INNER JOIN Categories ON Items.Categories_categoryID = Categories.categoryID LEFT JOIN Enchantments ON Items.Enchantments_enchantmentID = Enchantments.enchantmentID;'
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        query2 = 'SELECT * FROM Categories;'
        cur = mysql.connection.cursor()
        cur.execute(query2)
        categories = cur.fetchall()

        query3 = 'SELECT enchantmentID, enchantment_name FROM Enchantments;'
        cur = mysql.connection.cursor()
        cur.execute(query3)
        enchantments = cur.fetchall()

    return render_template('Items.j2', data=data, categories=categories, enchantments=enchantments)

@app.route('/Items_delete/<int:id>')
def delete_item(id):
    """Receives items ID and deletes the item."""
    query = "DELETE FROM Items WHERE itemID = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (id,))
    mysql.connection.commit()
    # Return to Items page after removing merchant
    return redirect("/Items")

@app.route('/Items_edit/<int:id>', methods=['POST', 'GET'])
def edit_item(id):
    """TODO"""
    if request.method == 'GET':
        # query for the item to update
        query = "SELECT * FROM Items WHERE itemID = %s;" %(id)
        cur = mysql.connection.cursor()
        cur.execute(query)
        item = cur.fetchall()

        # query for enchantments
        query2 = "SELECT enchantmentID, enchantment_name FROM Enchantments"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        enchantments = cur.fetchall()

        # query for categories
        query3 = "SELECT * FROM Categories"
        cur = mysql.connection.cursor()
        cur.execute(query3)
        categories = cur.fetchall()

        return render_template("Edit_Item.j2", item=item, enchantments=enchantments, categories=categories)
    
    if request.method == "POST":
        if request.form.get("Edit_Item"):
            id = request.form["itemID"]
            name = request.form["item_name"]
            item_class = request.form["class"]
            damage = request.form["damage"]
            weight = request.form["weight"]
            value = request.form["value"]
            category = request.form["Categories_categoryID"]
            enchantment = request.form["Enchantments_enchantmentID"]

            if enchantment == "0":
                query = "UPDATE Items SET Items.item_name = %s, Items.class = %s, Items.damage = %s, Items.weight = %s, Items.value = %s, Items.Categories_categoryID = %s, Items.Enchantments_enchantmentID = NULL WHERE Items.itemID = %s;"
                cur = mysql.connection.cursor()
                cur.execute(query, (name, item_class, damage, weight, value, category, id))
                mysql.connection.commit()

            else:
                query = "UPDATE Items SET Items.item_name = %s, Items.class = %s, Items.damage = %s, Items.weight = %s, Items.value = %s, Items.Categories_categoryID = %s, Items.Enchantments_enchantmentID = %s WHERE Items.itemID = %s;"
                cur = mysql.connection.cursor()
                cur.execute(query, (name, item_class, damage, weight, value, category, enchantment, id))
                mysql.connection.commit()

            return redirect("/Items")


@app.route('/Merchants_Items/<int:id>', methods = ['POST', 'GET'])
def merchants_items(id):
    if request.method == 'GET':
        if request.form.get('Select_Merchant'):
            id = request.query #request.form['merchantID']

        query = "SELECT itemID, item_name, class, damage, weight, value, Categories.category_name AS category, Enchantments.enchantment_name AS enchantment FROM Merchants_Items INNER JOIN Items on Merchants_Items.Items_itemID = Items.itemID LEFT JOIN Categories ON Items.Categories_categoryID = Categories.categoryID LEFT JOIN Enchantments ON Items.Enchantments_enchantmentID = Enchantments.enchantmentID WHERE Merchants_Items.Merchants_merchantID = '%s';"
        cur = mysql.connection.cursor()
        cur.execute(query, (id,))
        merchants_items = cur.fetchall()

        query2 = 'SELECT merchantID, merchant_name FROM Merchants;'
        cur = mysql.connection.cursor()
        cur.execute(query2)
        merchants_list = cur.fetchall()

        query3 = "SELECT * FROM Merchants WHERE merchantID = '%s';"
        cur = mysql.connection.cursor()
        cur.execute(query3, (id,))
        merchant = cur.fetchall()

        return render_template('Merchants_Items.j2', merchants_items = merchants_items, merchants_list = merchants_list, merchant=merchant)


@app.route('/Categories', methods = ['POST', 'GET'])
def categories():
    if request.method == "GET":
        query = "SELECT * FROM Categories;
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        return render_template('Categories.j2', data=data)

    if request.method =="POST":
        if request.form.get('Add_Category'):
            categoryID = request.form['categoryID']
            category_name = request.form['category_name']
            query = 'INSERT INTO Categories (categoryID, category_name) VALUES (%s, %s);'    
            cur = mysql.connection.cursor()
            cur.execute(query, (categoryID, category_name))
            mysql.connection.commit()
            return redirect('/Categories')


@app.route('/Categories_delete/<int:id>')
def categoriesDelete(id)
    query = "DELETE FROM Categories WHERE categoryID= '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (id,))
    mysql.connection.commit()
    # Return to categories page after removing merchant
    return redirect("/Categories")


@app.route('/Enchantments')
def enchantments():
    if request.method == "GET":
        query = "SELECT * FROM Enchantments;
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        return render_template('Enchantments.j2', data=data)

    if request.method =="POST":
        if request.form.get('Add_Enchantment'):
            enchantmentID = request.form['enchantmentID']
            enchantment_name = request.form['enchantment_name']
            school = request.form['school']
            query = 'INSERT INTO Enchantments (enchantmentID, enchantment_name, school) VALUES (%s, %s, %s);'    
            cur = mysql.connection.cursor()
            cur.execute(query, (enchantmentID, enchantment_name, school))
            mysql.connection.commit()
            return redirect('/Enchantments')

@app.route('/Enchantments_delete/<int:id>')
def delete_enchantment(id):
    query = "DELETE FROM Enchantments WHERE enchantmentID= '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (id,))
    mysql.connection.commit()
    # Return to enchantments page after removing merchant
    return redirect("/Enchantments")

@app.route('Locations/')
def location():
    if request.method == "GET":
        query = "SELECT * FROM Locations;
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        return render_template('Locations.j2', data=data)

    if request.method =="POST":
        if request.form.get('Add_Location'):
            hold = request.form['hold']
            locationID = request.form['locationID']
            location_name = request.form['location_name']
            location_type = request.form['location_type']
            query = 'INSERT INTO Locations (hold, locationID, location_name, location_type) VALUES (%s, %s, %s, %s);'    
            cur = mysql.connection.cursor()
            cur.execute(query, (hold, locationID, location_name, location_type))
            mysql.connection.commit()
            return redirect('/Locations')

@app.route('/Locations_delete/<int:id>')
def delete_location(id):
    query = "DELETE FROM Locations WHERE locationID= '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (id,))
    mysql.connection.commit()
    # Return to enchantments page after removing merchant
    return redirect("/Locations")




# Listener
if __name__ == "__main__":

    #Start the app on port 3000, it will be different once hosted
    app.run(host='http://flip2.engr.oregonstate.edu', port=55123, debug=True)