#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys, os
import xml.etree.ElementTree as ET
import urllib, json, datetime
import pymongo
from pymongo import MongoClient

client = MongoClient('localhost', 27017)
db = client.flights
flights = db.flights

xml_file   = open(sys.argv[1],"r")
xml_string = xml_file.read()
root = ET.fromstring("<rootElement>"+xml_string+"</rootElement>")

# out_filename = os.path.splitext(sys.argv[1])[0]+".json"
# try:
#     os.remove(out_filename)
# except OSError:
#     pass
# out_file = open(out_filename, 'wb')

date=datetime.datetime.strptime(os.path.splitext(sys.argv[1])[0][-10:],'%Y-%m-%d').strftime(' %d/%m/%Y')
schm="{http://www.aeroportsdeparis.fr/services/flightinfo}"
# flights_to_upsert = list()
for f in root.findall(".//"+schm+"Flight"):
  flight = {}
  flight['arrivalOrDepartDateTime'] = datetime.datetime.strptime(f.find(schm+'ArrivalOrDepartDateTime').text,"%Y-%m-%dT%H:%M:%S")
  arrivalTime=f.find(schm+'ArrivalTime').text.strip()
  departureTime=f.find(schm+'DepartureTime').text.strip()
  if len(arrivalTime)<5 or len(arrivalTime)==16:
    flight['arrivalTime']=None
  else:
    if len(arrivalTime)==5:
      arrivalTime=arrivalTime+date
    flight['arrivalTime']   = datetime.datetime.strptime(arrivalTime  ,'%H:%M %d/%m/%Y')
  if len(departureTime)<5 or len(departureTime)!=16:
    flight['departureTime']=None
  else:
    if len(departureTime)==5:
      departureTime=departureTime+date
    flight['departureTime'] = datetime.datetime.strptime(departureTime,'%H:%M %d/%m/%Y')
  flight['cityName'] = f.find(schm+'CityInfo/'+schm+'Name').text
  flight['cityCode'] = f.find(schm+'CityInfo/'+schm+'Code').text
  flight['_id'] =  f.find(schm+'CompositeKey').text
  flight['countryName'] = f.find(schm+'CountryInfo/'+schm+'Name').text
  flight['countryCode'] = f.find(schm+'CountryInfo/'+schm+'Code').text
  flight['flightCompanyCode'] = f.find(schm+'FlightCompanyName').text
  flight['flightCompanyName'] = f.find(schm+'FlightCompanyCode').text
  flight['flightLineNumber']  = f.find(schm+'FlightLineNumber').text
  flight['flightName']  = f.find(schm+'FlightName').text
  flight['flightSequenceNumber'] = f.find(schm+'FlightSequenceNumber').text
  flight['isArrival'] = f.find(schm+'IsArrival').text
  flight['planeType'] = f.find(schm+'PlaneType').text
  flight['status']  = f.find(schm+'Status').text.encode('utf8')
  flight['terminal']  = f.find(schm+'Terminal').text
  flight['terminalLongName']  = f.find(schm+'TerminalLongName').text
  #flights_to_upsert.append(flight)
  #flights.save(flights_to_upsert)
  flights.save(flight)
#print flights.find_one()
print flights.count()

