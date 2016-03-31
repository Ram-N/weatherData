[![Build Status](https://travis-ci.org/Ram-N/weatherData.png?branch=master)](https://travis-ci.org/Ram-N/weatherData)

weatherData is a library of functions that will fetch weather data (Temperature, Pressure, Humidity, Wind Speed etc.) from the Web for you as a clean data frame.

If you want to perform weather Analysis, but don't wish to be bothered with scraping the data yourself, you can consider using `weatherData`.

### Github Page with Examples

The main page for weatherData (with explanations and Examples) can be found
at [http://ram-n.github.io/weatherData/](http://ram-n.github.io/weatherData/)

### Shiny App

WeatherCompare is [a Shiny App](http://spark.rstudio.com/ram/WeatherCompare/) that uses the data brought over by weatherData and then summarized in various ways

# Install 

To install the development version of weatherData from github, use the **devtools** package.

```r
install.packages("devtools")
library("devtools")
install_github("Ram-N/weatherData")
```

Load the library
```r
library(weatherData)
```

Windows users must also first install
[Rtools](http://cran.rstudio.com/bin/windows/Rtools/).

## Suggestions

Suggestions are welcome! If you would have a particular need for weather data,
let me know what changes you'd like to see in the package. If you find bugs, please do report it. Fetching data from the web can be fragile.
Submit an Issue.

# How to Use this package

## Examples 


```r
library(weatherData)
checkDataAvailabilityForDateRange("SFO", "2010-10-29", "2013-01-12")
```

The command above will see if weather data is available for the Airport supplied ("SFO") for the two end dates supplied: for the 20th Oct 2010 and for Jan 12th 2013 in this case.

This command is useful for a quick check, before invoking `getDateRangeWeather`

```r
data(London2013)
```
This is a data frame of Ambient temperature data, extracted
from Weather Undergound. Each row has two entries
(columns). The Timestamp (YYYY-MM-DD HH:MM:SS) and the
TemperatureF (in degrees F) 


```r
getCurrentTemperature("PIT")
```

This function will get the latest recorded Temperature for a give city or station. Any valid US Airport code or International 4-letter Airport Weather Code is valid. For example "EGLL" for London, UK. 
Note: This function uses the Sys.Date to learn today's date

```r
getStationCode("Buffalo")
getStationCode("Buffalo", state="WY")
```

This function will return a record containing matches to a given
station name, and the 4 letter code can then be used in the arguments
to other functions such as `getWeatherForDate()`


More examples (with explanations) can be found
at [http://ram-n.github.io/weatherData/](http://ram-n.github.io/weatherData/)

