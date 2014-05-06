---
layout: default
title: Credits
---

##More Examples


### How to find the `station_id` for a Location

Let's say that we want to search for weather in Buffalo. But we are interested in Buffalo, WY, not Buffalo,NY.

    getStationCode("Buffalo")
    
	#If we want to be more specific about the location of interest
	#We can specify the additional parameter region
    getStationCode("Buffalo", region="WY") 
	
  <p>This function will return a record containing matches to a given station name, and the 4 letter code can then be used in the arguments to other functions such as <code>getWeatherForDate()</code>

    > getStationCode("Buffalo", region="WY") 	  
	  [[1]]
	       Station State airportCode
	  1588 Buffalo    WY        KBYG
	  
So, we can see that the 4-letter airportCode that we are interested in is <code>KBYG</code></p>
  
  

  <h3>
  <a name="check-if-data-is-available" class="anchor" href="#check-if-data-is-available"><span class="octicon octicon-link"></span></a>Check if Data is Available</h3>

  <p>In general, it is a good idea to first check if data is available for our location and dates of interest. Throughout the package, we make a distinction between a <strong>Date</strong> and a <strong>Date Range</strong></p>

    checkDataAvailability("KBYG", "2011-01-02") #checking for a single date
    checkDataAvailabilityForDateRange("SFO", "2010-10-29", "2013-01-12") #checking for a date range

  <p>The first command searches for Data Availability (in Weather Underground) for the date specified.
  The second command above will see if weather data is available for the Airport supplied ("SFO") for the two end dates supplied: for the 20th Oct 2010 and for Jan 12th 2013 in this case.</p>

  <p>These commands are useful for a quick check, before invoking <code>getDateRangeWeather</code></p>

    getCurrentTemperature("PIT")

  <p>If you are writing functions that use the current (latest) temperature for any location, you could use the
  <code>getCurrentTemperature</code> function. This function will get the latest recorded Temperature for a give city or station. Any valid US Airport code or International 4-letter Airport Weather Code is valid. For example "EGLL" for London, UK. This function returns a NULL if it is unable to fetch the temperature, so you can test for that using <code>is.null()</code></p>

  <p>Note: This function uses the Sys.Date to learn today's date</p>

### List of the different functions available in weatherData

####Functions to Check if Data is available
* `checkDataAvailability`	Check if WeatherUnderground has Data for given station and date
* `checkDataAvailabilityForDateRange`	Quick Check to see if WeatherUnderground has Weather Data for given station for a range of dates
* `checkSummarizedDataAvailability`	Quick Check to see if WeatherUnderground has Summarized Weather Data for given station for a custom range of dates


#### Helper Functions
* `showAvailableColumns`	Shows all the available Weather Data Columns
* `getStationCode`	Gets the Weather Station code for a location (in the US)
* `getCurrentTemperature`	Get the latest recorded temperature for a location


#### Core Functions that fetch Weather Data
* `getDetailedWeather`	Gets weather data for a single date (All records)
* `getSummarizedWeather`	Gets daily summary weather data (One record per day)

#### Convenience Wrappers
* `getTemperatureForDate`	Getting Temperature data for a single date (or a range of dates)
* `getWeatherForDate`	Getting data for a range of dates
* `getWeatherForYear`	Get weather data for one full year


####Built-in Datasets
There are also a number of data sets that come with the package. Be sure to [check them out](builtin.html) as well.

[Back](index.html)

