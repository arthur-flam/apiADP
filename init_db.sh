#!/bin/bash
# start mongo database
mkdir data
mongod --dbpath /home/$USER/apiadp/data --smallfiles &
