from flask import Flask, jsonify, request, render_template, make_response, redirect
from flask_cors import CORS
import psycopg2
import os
from datetime import datetime, timedelta

app = Flask(__name__)
cors = CORS(app, origins=["http://localhost:49998"], methods=["GET", "POST"])

@app.route( '/login' )
def login():
	return render_template('index.html')

@app.route( '/user-registration' )
def userRegistration():
    return render_template('userRegistration.html')

@app.route('/check_login/<username>/<password>')
def check_login( username, password ):
    # get login information submitted by the user
    #username = request.form['username']
    #password = request.form['password']

    print(f"username: {username}, password: {password}")

    # connect to the database
    conn = psycopg2.connect(
        dbname="userdb",
        user="demo",
        password="password",
        host="localhost",
        port="5432"
    )
    cur = conn.cursor()

    # verify login credentials against the database
    cur.execute("SELECT * FROM users WHERE username=%s AND password=%s", (username, password))
    result = cur.fetchone()

    if result is None:
        # login failed
        response = jsonify({'message': 'Invalid username or password'})
        response.status_code = 401
    else:
        # login successful
        session_id = os.urandom(16).hex()
        response = jsonify({'message': 'Login successful'})
        response.set_cookie('session_id', session_id, secure=True, httponly=True)
        response.status_code = 200
        # Saving cookie in database
        expiry_time = datetime.now() + timedelta(minutes=30)
        cur.execute("INSERT INTO sessions (session_id, username, expiry_time) VALUES (%s, %s, %s)", (session_id, username, expiry_time))
        conn.commit()

    # close database connection and return response
    cur.close()
    conn.close()
    return response

@app.route('/check_session', methods=['GET'])
def check_session():
  # connect to the database
  conn = psycopg2.connect(
    dbname="userdb",
    user="demo",
    password="password",
    host="localhost",
    port="5432"
  )
  cur = conn.cursor()
  session_id = request.cookies.get('session_id')
  player_id = request.args.get('player_id')
  cur = conn.cursor()
  cur.execute("SELECT expiry_time, username FROM sessions WHERE session_id = %s", [session_id])
  result = cur.fetchone()
  print("The session ID I recieved:", session_id)
  print("I found in database:", result)

  if not result or result[0] < datetime.now() or result[1] != player_id:
    print("Login unauthorised")
    return jsonify({'status': 'NoCookie'}), {'Access-Control-Allow-Origin': 'http://localhost:49998', 'Access-Control-Allow-Credentials': 'true'}
  else:
    print("Login confirmed")
    expiry_time = datetime.now() + timedelta(minutes=30)
    cur.execute("UPDATE sessions SET expiry_time = %s WHERE session_id = %s", [expiry_time, session_id])
    conn.commit()
    return jsonify({'status': 'success'}), {'Access-Control-Allow-Origin': 'http://localhost:49998', 'Access-Control-Allow-Credentials': 'true'}

@app.route('/register_new_user/<username>/<password>')
def register_new_user( username, password):
    print(f"username: {username}, password: {password}")
    conn = psycopg2.connect(
        dbname="userdb",
        user="demo",
        password="password",
        host="localhost",
        port="5432"
    )
    cur = conn.cursor()
    cur.execute("SELECT * FROM users WHERE username=%s", (username,))
    result = cur.fetchone()
    if result is None:
        # user can be created
        cur.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, password))
        conn.commit()
        cur.execute("SELECT * FROM users WHERE username=%s AND password=%s", (username, password))
        result = cur.fetchone()
        print("user that was created:", result)
        if result is None:
            response = jsonify({'message': 'Something went wrong in user creation'})
            response.status_code = 401
        else:
            response = jsonify({'message': 'New user created'})
            response.status_code = 200
    else:
        # existing user found
        response = jsonify({'message': 'User already exists'})
        response.status_code = 402

    # close connection
    cur.close()
    conn.close()
    return response

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
