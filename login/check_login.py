from flask import Flask, jsonify, request, render_template, session
import psycopg2

app = Flask(__name__)

app.secret_key = '9c6183b4f5ea06b2a1b918f17f7bd05fbd6271fd67cc576c9b080ab6061d459f'

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
        response = jsonify({'message': 'Login successful'})
        session["username"] = username
        response.status_code = 200

    # close database connection and return response

    cur.execute("SELECT * FROM users")
    result = cur.fetchall()
    for all in result:
        print(all)
    cur.close()
    conn.close()
    return response

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
    cur.execute("SELECT * FROM users")
    result = cur.fetchall()
    for all in result:
        print(all)
    cur.close()
    conn.close()
    return response

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
