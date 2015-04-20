#!/bin/bash
mkdir data

from=$(date +"%Y-%m-%d" --date="7 days ago")
today=$(date +"%Y-%m-%d")
to=$(date +"%Y-%m-%d" -d "3 months")

current=$from
while [ "$to" != "$current" ] ; 
do 
    ./getFlights.sh $current
    file=data/flights-$current.xml
    ./load.py $file && \
	gsutil cp $file gs://adp-flights/$today/$current.xml 
    current=$(date +"%Y-%m-%d" -d "$current + 1 day"); 
done



