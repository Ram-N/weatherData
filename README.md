# Install 

To install the development version of weatherData from github, use the **devtools** package.

```r
library("devtools")
install_github("weatherData", "Ram-N")
```

Windows users also must first install
[Rtools](http://cran.rstudio.com/bin/windows/Rtools/).

## Suggestions

Suggestions are welcome! If you would have a particular need for weather data,
let me know what changes you'd like to see in the package.
Submit an Issue.

# How to Use this package

## Examples 


```
library(weatherData)
IsStationDataAvailable("SFO", "airportCode", "2010-10-29", "2013-01-12")
```

The command above will see if weather data is available for the two end dates supplied: for the 20th Oct 2010 and for Jan 12th 2013.



