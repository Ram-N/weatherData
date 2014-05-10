---
layout: default
title: Example - Wind Data
---

###Example showing How to Get Detailed Wind Data

For this example, we are interested in Wind data for the town of Barrow in Alaska. We need to find the airport code, then we have to find out
which columns are relevant, and then we can fetch the data we need.
	
    library(weatherData)

####First, get the station code

    getStationCode("Barrow")

    [[1]]
       Station State airportCode
    18  Barrow    AK        PABR
    
    [[2]]
    [1] "USA AK BARROW           PABR  BRW   70026  71 17N  156 48W    7   X     T  X  A    5 US"      
    [2] "USA AK BARROW ARM-NSA               70027  71 19N  156 37W    7            X       8 US"      
    [3] "USA GA WINDER/BARROW    KWDR  WDR          33 59N  083 40W  287   X                7 US"      
    [4] "AUSTRALIA    BARROW ISLAND    YBWX        94304  20 53S  115 24E    6   X                8 AU"


Either the 4-letter code PABR or the airport code BRW would work.


####Which columns relate to Wind?


   	> showAvailableColumns("PABR", "2014-01-01", opt_detailed=T)
      	columnNumber           columnName
   	1             1             TimeAKST
   	2             2         TemperatureF
   	3             3           Dew_PointF
   	4             4             Humidity
   	5             5 Sea_Level_PressureIn
   	6             6        VisibilityMPH
   	7             7       Wind_Direction
   	8             8        Wind_SpeedMPH
   	9             9        Gust_SpeedMPH
   	10           10      PrecipitationIn
   	11           11               Events
   	12           12           Conditions
   	13           13       WindDirDegrees
   	14           14              DateUTC

So the columns we are interested in are 7, 8 and 13, because they relate to Wind. Please note that the column numbers are very different depending on whether or not `opt_detailed` is TRUE or FALSE.

So we know that when fetching the data, we have to set `opt_custom_columns=TRUE` and  `custom_columns=c(7,8,13).` 

We are now ready to actually fetch the data.

	
####Fetch the Data

    getWeatherForDate("BRW", start_date="2014-01-01", 
                      opt_detailed=T,
                      opt_custom_columns=T, custom_columns=c(7,8,13))

    Checking Data Availability For BRW
    Found Records for 2014-01-01
    Data is Available
    Will be fetching these Columns:
    [1] "Time"           "Wind_Direction" "Wind_SpeedMPH" 
    [4] "WindDirDegrees"
    Begin getting Daily Data for BRW
    BRW 1 2014-01-01 : Fetching 27 Rows with 4 Column(s)
                      Time Wind_Direction Wind_SpeedMPH WindDirDegrees
    1  2014-01-01 00:53:00            ENE          27.6             70
    2  2014-01-01 01:53:00            ENE          24.2             70
    3  2014-01-01 02:53:00            ENE          26.5             70
    4  2014-01-01 03:53:00            ENE          31.1             70
    5  2014-01-01 04:53:00            ENE          28.8             70
    6  2014-01-01 05:53:00            ENE          31.1             70
	...
	...

We can save these values in a data frame and start the actual analysis.

	
[<< Back to Examples](index.html#moreexamples)

