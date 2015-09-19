# Install system dependencies
sudo apt-get update
sudo apt-get --yes --force-yes install python-pip python-dev nginx

# Install virtualenv
sudo pip install virtualenv

# Request the Flask code directory
echo "Please input the folder containing the flask code: "
read DIR
# Request the user name
echo "Please input the user to host the website: "
read USER

# Request the public server domain of the website
echo "Please input the public server domain of the website: "
read DOMAIN

# Copy over .ini file from folder to DIR
cp config.ini ~/$DIR/$DIR.ini
vim -esnc '%s/<myproject>/$DIR/g|:wq' ~/$DIR/$DIR.ini

# Copy over wsgi.py file from folder to DIR
cp wsgi.py ~/$DIR
vim -esnc '%s/<myproject>/$DIR/g|:wq' ~/$DIR/wsgi.py

# Copy over Upstart file
sudo cp upstart.conf /etc/init/$DIR.conf
vim -esnc '%s/<user>/$USER/g|:wq' /etc/init/$DIR.conf
vim -esnc '%s/<myproject>/$DIR/g|:wq' /etc/init/$DIR.conf

# Copy over nginx config
cp nginx.config /etc/nginx/sites-available/$DIR
vim -esnc '%s/<user>/$USER/g|:wq' /etc/nginx/sites-available/$DIR
vim -esnc '%s/<domain>/$DOMAIN/g|:wq' /etc/nginx/sites-available/$DIR
vim -esnc '%s/<myproject>/$DIR/g|:wq' /etc/nginx/sites-available/$DIR

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
sudo start $DIR

# Enable the Nginx server block config
sudo ln -s /etc/nginx/sites-available/$DIR /etc/nginx/sites-enabled

# Test for syntax errors in Nginx server config
sudo nginx -t

# Start nginx server
sudo service nginx restart


