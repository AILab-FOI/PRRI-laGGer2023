This file describes the setup process for the login screen

Install:
sudo apt-get install python3-psycopg2 postgresql
sudo ufw allow 5000

for python install:
python3 -m pip install flask_cors

Execute init.sql in PostgreSQL:
1. Move init.sql to home(~) directory
2. sudo chmod 777 init.sql
3. sudo -u postgres psql
4. \ir /home/lagger/init.sql
5. \q

(OPTIONAL) Run the login page to check if it works:
python3 check_login.py