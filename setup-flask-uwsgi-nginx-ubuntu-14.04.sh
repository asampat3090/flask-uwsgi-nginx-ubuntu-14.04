# Install system dependencies
sudo apt-get update
sudo apt-get --yes --force-yes install python-pip python-dev nginx

# Install virtualenv
sudo pip install virtualenv

# Request flask code directory 
echo "Please input the folder containing the flask code: "
read DIR

# Copy over .ini file from folder to DIR
cp config.ini ~/$DIR/$DIR.ini
vim -esnc '%s/<myproject>/$DIR/g|:wq' ~/$DIR/$DIR.ini

# Copy over wsgi.py file from folder to DIR
cp wsgi.py ~/$DIR
vim -esnc '%s/<myproject>/$DIR/g|:wq' ~/$DIR/wsgi.py

# Copy over Upstart file
sudo cp upstart.conf /etc/init/$DIR.conf
vim -esnc '%s/<user>/ubuntu/g|:wq' /etc/init/$DIR.conf
vim -esnc '%s/<myproject>/$DIR/g|:wq' /etc/init/$DIR.conf

# Copy over nginx config
cp nginx.config /etc/nginx/sites-available/$DIR

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



