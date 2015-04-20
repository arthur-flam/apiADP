# apiADP #
This tool lets you query flight information from and to Paris airports.
You can get quite a lot of information : are plane late ? cancelled ? why ?

It uses a private API from the mobile app.
Keep in mind this is very much a few queries put together as a proof of concept.

## Setup ##
Some dependencies can be installed through the setup script.

## How to get scrapping ##
1. please get your own tokens through the mobile app (todo: find the request that creates them during the app install).
2. start the mongo database with the `init_db.sh`
3. run `./scrap.sh`

## Todo ? ##
- analytics and vizualisation layer
- what about flights that are cancelled and just stop showing up in the data ?
- find what to scrap and what can wait...