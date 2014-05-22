
app server
===========================

gem install unicorn

* First we will create a new user for deployment:
$ ssh into your server
$ sudo adduser deploy

( Accept the defaults.)

- user : deploy
- pass : welcome123

* Add new user to staff and sudo groups:
$ sudo usermod -a -G staff deploy
$ sudo usermod -a -G sudo deploy

* Switch user:
$ su deploy
$ cd ~
    
* Update packages
$ sudo apt-get -y update
* Install curl to install rvm
$ apt-get install curl

Install rvm:
curl -L get.rvm.io | bash -s stable

Then make it available in your current shell:
source ~/.rvm/scripts/rvm

# In order to work, RVM has some of its own dependancies that need to be installed. To automatically install them: 
$ rvm requirements

* Installing RVM
$ rvm install 1.9.3
$ rvm use 1.9.3 --default

* Update rubygems just in case:
$ rvm rubygems current

gem install bundler

Finally, at some point, chances are that you’re going to install some gem requiring Nokogiri which requires additional packages, so let’s install those packages beforehand:

sudo apt-get install libxslt-dev libxml2-dev


* To work with mysql [mysql dependencies]
$ sudo apt-get install libmysqld-dev libmysqlclient-dev mysql-client


Nginx
======
* Install Nginx
$ sudo apt-get install nginx
* Run Nginx
$ sudo service nginx start

* Configure nginx
$ sudo nano /etc/nginx/nginx.conf

sudo mkdir /home/deploy/apps/testapp1/current
sudo chown deploy:deploy /home/deploy/apps/testapp1/current

