# Author: Ram Narasimhan

#weather data retrieval from the WEB
# Mainly interested in Daily/Hourly Temperatures, given Locations

#WEB RESOURCES
# example from: http://casoilresource.lawr.ucdavis.edu/drupal/node/991
# for Excel http://craigsimpson.net/2012/09/getting-rain-fall-inches-in-python/

# To get a single day's worth of (hourly) data
#USAGE: w <- wunder_station_daily('KCAANGEL4', as.Date('2011-05-05'))


#Note that URL's should be of the form:
#FORMAT Call SIGN: KCASUNNY
#http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=KCASUNNY13&month=1&day=1&year=2011&format=1

#The format for AIRPORT Weather DATA:
# http://www.wunderground.com/history/airport/KPHX/2010/11/18/DailyHistory.html?format=1
#http://www.wunderground.com/history/airport/K<3-letter airport code>/2010/11/18/DailyHistory.html?format=1


#station2 ='KCASUNNY13'
#start_date = '2011-01-01'
#end_date = '2011-12-31'

#get_Wx_data_for_date_range(station1,start_date, end_date)


Austin, AUS
Houston, IAH
San antonio, SAT
Raleigh, RDU
Charleston, CHS
Ashville, AVL
Greenville, PGV
Jacksonville, JAX
The Villages
Shantiniketan, LEE
Miami
Orlando, FL
Tampa
Los angeles
Palm springs


#source("R/weatherData_lib.R")
df <- FetchDailyWeatherForStation("PHX",start_date, opt.temp.only=T, station.type="airportCode")

IsStationDataAvailable("LEE", "airportCode", "2012-01-01", "2012-12-31")
IsStationDataAvailable("KCASANTA142","ID", "2012-01-01", "2012-12-31")


#Testing purposes
start_date = "2013-01-01"
end_date = "2013-01-03"
lst=list("LEE")
lapply(lst, IsStationDataAvailable, "airportCode", start_date, end_date)
#You should get non-zero records.

#Print out what you are getting
FetchDailyWeatherForStation(lst, "2013-01-31", "airportCode", opt.debug=T)


#-- Test if able to fetch data

setwd("~/Py Library/Wx/data/input/")
cityId <- "LEE"
lapply(lst, FetchStationWeatherForDateRange, "airportCode", start_date, end_date)
file.info(paste0(cityId, ".csv.gz"))


FetchStationWeatherForDateRange(cityId,"ID", start_date, end_date)
file.info(paste0(cityId, ".csv.gz"))

#------------

start_date = "2012-01-01"
end_date = "2012-12-31"

lst1 = list("JAX", "AVL", "SAT", "AUS", "IAH", "PSP", "TPA")
lapply(lst2, IsStationDataAvailable, "airportCode", start_date, end_date)

#lapply(lst, IsStationDataAvailable, "ID", start.date, end.date)

lapply(lst1, FetchStationWeatherForDateRange, "airportCode", start_date, end_date)
length(lst)

start_date = "2013-01-01"
end_date = "2013-12-31"
lst = list("JAX", "AVL", "SAT", "AUS", "IAH", "PSP", "TPA")
lapply(lst2, FetchStationWeatherForDateRange, "airportCode", start_date, end_date)
file.info(paste0(lst[2], ".csv.gz"))

##------------
RAs list:
              2012            2013
PDX   0 X          
LAX
SFO
IAH 0 x
MIA   0 x 
RDU  x x
ATL 0 X
TPA x x
HNL
LGA 0 x
SYD
Brisbane BNE
LHR
SIN
BOM (Mumbai)

lst2 <- c("PDX", "IAH", "ATL", "LGA")
lst3 <- c("SYD", "BBE", "LHR", "SIN", "BOM")


