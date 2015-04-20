#!/bin/bash
date=$1

function getFlights {
day=$1
start=$day'T00:00:00'
end=$day'T23:59:00'
isArrival=$2 # true or false
echo 'fetching flights from'$start' to '$end' [arrivals:'$isArrival']'

curl --url http://services.aeroportsdeparis.fr/FlightInfoWebService/FlightInfoService.svc \
--user-agent 'My%20Airport/7.3 CFNetwork/672.1.15 Darwin/14.0.0' \
--header 'Host: services.aeroportsdeparis.fr' \
--header 'Accept-Encoding: gzip, deflate' \
--header 'Content-Type: application/soap+xml; charset=utf-8' \
--header 'Accept-Language: fr-fr' \
--header 'Accept: */*' \
--header 'Connection: keep-alive' \
--data '
<s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope" xmlns:a="http://www.w3.org/2005/08/addressing">
<s:Header>
<a:Action s:mustUnderstand="1">http://www.aeroportsdeparis.fr/services/flightinfo/IFlightInfo/SearchFlights</a:Action>
<h:Language xmlns:h="http://www.aeroportsdeparis.fr/services/flightinfo" xmlns="http://www.aeroportsdeparis.fr/services/flightinfo">FR</h:Language>
<h:Token xmlns:h="http://www.aeroportsdeparis.fr/services/flightinfo" xmlns="http://www.aeroportsdeparis.fr/services/flightinfo">f2a40b7e-eb7c-4059-bb19-f4ac9e782e38</h:Token>
<a:ReplyTo>
<a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address>
</a:ReplyTo>
<a:To s:mustUnderstand="1">http://services.aeroportsdeparis.fr/FlightInfoWebService/FlightInfoService.svc</a:To>
</s:Header>
<s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<SearchFlightsRequest xmlns="http://www.aeroportsdeparis.fr/services/flightinfo">
<SearchCriteria>
<EndDateTime>'$end'</EndDateTime>
<FlightCompany />
<FlightNumber />
<IsArrival>'$isArrival'</IsArrival>
<StartDateTime>'$start'</StartDateTime>
</SearchCriteria>
</SearchFlightsRequest>
</s:Body>
</s:Envelope>' > data/flights-$day-$isArrival.xml
}
getFlights $date true 
sleep 1
getFlights $date false
sleep 1

file=data/flights-$date.xml
rm -f $file && touch $file
cat data/flights-$day-true.xml >> $file
rm  data/flights-$day-true.xml
cat data/flights-$day-false.xml >> $file
rm  data/flights-$day-false.xml

#<City>BARCELONE</City>
#<Country>ES</Country>
# grep -o '<Code>.\{0,10\}</Code>' flights-2014-10-09.xml | sort | uniq -c | sort
