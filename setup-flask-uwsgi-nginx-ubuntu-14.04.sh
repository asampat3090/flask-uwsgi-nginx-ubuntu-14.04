# Install system dependencies
sudo apt-get update
sudo apt-get --yes --force-yes install python-pip python-dev nginx

# Install virtualenv
sudo pip install virtualenv

# Request the Flask code directory
read -p  "Please input the folder containing the flask code: " DIR

# Request the user name
read -p "Please input the user to host the website: " USER

# Request the public server domain of the website
read -p "Please input the public server domain of the website: " DOMAIN

# Copy over .ini file from folder to DIR
sudo sed 's/<myproject>/'$DIR'/g' config.ini > ~/$DIR/$DIR.ini

# Copy over wsgi.py file from folder to DIR
sudo sed 's/<myproject>/'$DIR'/g' wsgi.py > ~/$DIR/wsgi.py

# Copy over Upstart file
sudo sed 's/<user>/'$USER'/g' upstart.conf > /etc/init/$DIR.conf
sudo sed -i 's/<myproject>/'$DIR'/g' /etc/init/$DIR.conf

# Copy over nginx config
sudo sed 's/<user>/'$USER'/g' nginx.config >/etc/nginx/sites-available/$DIR
sudo sed -i 's/<domain>/'$DOMAIN'/g' /etc/nginx/sites-available/$DIR
sudo sed -i 's/<myproject>/'$DIR'/g' /etc/nginx/sites-available/$DIR

# Create virtualenv
cd ~/$DIR
virtualenv env
source env/bin/activate

# Install python requirements
pip install uwsgi
pip install -r requirements.txt

# Deactivate python virtualenv
deactivate

# Start Upstart process
sudo start $DIR &

# Enable the Nginx server block config
sudo ln -s /etc/nginx/sites-available/$DIR /etc/nginx/sites-enabled

# Test for syntax errors in Nginx server config
sudo nginx -t

# Start nginx server
sudo service nginx restart &
