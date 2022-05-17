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
    return redirect('/Merchants')#render_template("Merchants.j2")

@app.route('/Merchants', methods=['POST', 'GET'])
def merchants():
    if request.method == 'POST':
        #if press add
        if request.form.get('Add_Merchant'):
            merchant_name = request.form['merchant_name']
            race = request.form['race']
            shop_name = request.form['shop_name']
            gold = request.form['gold']
            location = request.form['location']    

            query = 'INSERT INTO Merchants (merchant_name, race, shop_name, gold, Locations_locationID) VALUES (%s, %s, %s, %s, %s);'    
            cur = mysql.connection.cursor()
            cur.execute(query, (merchant_name, race, shop_name, gold, Locations_locationID))
            mysql.connection.commit()
        
        return redirect('/Merchants')

    if request.method == 'GET':
        query = 'Select * from Merchants'
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        results = json.dumps(data)

        query2 = 'SELECT locationID, location_name FROM Locations;'
        cur = mysql.connection.cursor()
        cur.execute(query2)
        location_data = cur.fetchall()
        results2 = json.dumps(location_data)

        return render_template('Merchants.j2', data=data, location_data=location_data)



# Listener
if __name__ == "__main__":

    #Start the app on port 3000, it will be different once hosted
    app.run(host='http://flip2.engr.oregonstate.edu', port=55123, debug=True)