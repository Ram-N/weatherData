weatherData version 0.3
=====
Things to do for version 0.3

## Rationalize functionNames
     get vs check
     SingleDay vs DateRange vs Current
     Temp vs Weather

Factor Code into different R files

utils.R
wrapper_functions.R



## Planned features

Priority | Feature
---------|------
  High |  getCurrentTemp("RDU")
  High |  getAirportCode()
  Med  |  Get a whole year's worth of data easily
  Med  |  getAnnualTemp("SEA", 2013)
  Med  |  Get System.Time for how long something takes
  Med  |  getMax for a day
  Med  |  getMinTemp for a day
 Low  |   summarize by Hour
 Low | getTempForDateAndHour(station, date, hour) 
 Low | Plotting for data obtained
 
  
    