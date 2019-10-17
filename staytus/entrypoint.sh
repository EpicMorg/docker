#!/bin/bash

: ${DB_USER:=root}
: ${DB_PASSWORD:=root}
: ${DB_DB_DATABSE:=staytus}
: ${DB_HOST:=127.0.0.1}
#: ${DB_PORT:=3306}

cd /opt/staytus

# Configure DB with random password, if not already configured
if [ ! -f /opt/staytus/persisted/config/database.yml ]; then
  export DB_PASSWORD=${DB_PASSWORD}

  mysqladmin -u root -ptemp-password password ${DB_PASSWORD}
  echo "CREATE DATABASE staytus CHARSET utf8 COLLATE utf8_unicode_ci" | mysql -u root -p${DB_PASSWORD}

  cp config/database.example.yml config/database.yml
  sed -i "s/username:.*/username: ${DB_USER}/" config/database.yml
  sed -i "s|password:.*|password: ${DB_PASSWORD}|" config/database.yml
  sed -i "s|host:.*|host: ${DB_HOST}|" config/database.yml
  sed -i "s|database:.*|database: ${DB_DATABSE}|" config/database.yml

  # Copy the config to persist it, and later copy back on each start, to persist this config file 
  # without persisting all of /config (which is mostly app code)
  mkdir /opt/staytus/persisted/config
  cp config/database.yml /opt/staytus/persisted/config/database.yml

  bundle exec rake staytus:build staytus:install
else
  # Use the previously saved config from the persisted volume
  cp /opt/staytus/persisted/config/database.yml config/database.yml
  # TODO also copy themes back and forth too

  # If already configured, check if there are any migrations to run
  bundle exec rake staytus:build staytus:upgrade
fi

bundle exec foreman start