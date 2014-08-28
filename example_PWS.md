---
layout: default
title: Example of getting data from a Personal Weather Station
---

###Example showing How to Get Data from a Personal Weather Station

Broadly, there are two types of stations. Some are the 'official' airport weather stations. But there are also 1000s of Personal Weather Stations (PWS's) that are part of the weather underground network.

Let's say that we are interested in getting data from one of those stations.

First, we need to get the station code.To do that, it is easiest to go to the weather underground webpage.
For example, to find the weather stations near MIAMI, FL, we could try this page:
http://www.wunderground.com/cgi-bin/findweather/hdfForecast?query=Miami%2C+Florida

Then click on the 'change station' tab, and that gives us dozens of PWS nearby.

Let us use the one of these stations for this example, with the code of **KFLMIAMI88.** That code is important, because we use that in the functions.
	
####Usage: getSummarizedWeather(stationID, start_date, end_date, station_type="id")

    library(weatherData)

	getSummarizedWeather("KFLMIAMI88", "2014-02-02", end_date="2014-02-20", station_type="id") 

If you wanted some specific columns, you can use custom columns to get the ones that you desire.

	getSummarizedWeather("KFLMIAMI88", "2014-02-02", end_date="2014-02-20", station_type="id",
                     opt_custom_columns=T,
                     custom_columns= c(5,16))

which produces:

	       Date DewpointHighF PrecipitationSumIn
	1  2014-02-02            71               0.07
	2  2014-02-03            72               0.00
	3  2014-02-04            72               0.00
	4  2014-02-05            73               0.00
	5  2014-02-06            72               0.00
	6  2014-02-07            71               0.00
	7  2014-02-08            72               0.00
	8  2014-02-09            69               0.00
	9  2014-02-10            68               0.00
	10 2014-02-11            69               0.00
	11 2014-02-12            70               0.57
	12 2014-02-13            68               0.06
	13 2014-02-14            54               0.00
	14 2014-02-15            61               0.00
	15 2014-02-16            57               0.00
	16 2014-02-17            60               0.00
	17 2014-02-18            62               0.00
	18 2014-02-19            67               0.00
	19 2014-02-20            71               0.00

Once we have the data in a data frame. We can plot the data or carry out further analysis with the data frame.

	
[<< Back to Examples](index.html#moreexamples)

