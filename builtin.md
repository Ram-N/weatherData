---
layout: default
title: Built-in Datasets
---
 
 

`data(London2013)`

This is a data frame of Ambient temperature data, extracted from Weather Undergound. Each row has two entries (columns). 
 
 - The Timestamp (YYYY-MM-DD HH:MM:SS) and the
 - TemperatureF (in degrees F)
 
####Other Datasets Available
 * `Mumbai2013`		Data - Ambient Temperature for the City of Mumbai, India for all of 2013
 * `NewYork2013`	Data - Ambient Temperature for New York City for all of 2013
 * `SFO2012`		Data - Ambient Temperature for the City of San Francisco for all of 2012
 * `SFO2013`		Data - Ambient Temperature for the City of San Francisco for all of 2013
 * `SFO2013Summarized`  Data - Ambient Temperature for SFO, for 2013. (365 rows, one per day)
 
####Example of Using the Built-in Data Frame	
<h6>Say you wanted to find out the Date and Time in 2013 when it was hottest in Mumbai</h6>
 
We can use the built-in Dataset for this:
 
    > max(Mumbai2013$Temperature)
	 [1] 102.2
	 
By using `which.max` we can find the row in specific row in the data set. Once we get the data set, we can
print out other relavant details as well.

    > which.max(Mumbai2013$Temperature)
	 [1] 3212 
	 
Putting it together:
	 
    > Mumbai2013[which.max(Mumbai2013$Temperature), ]
                         Time Temperature
     3212 2013-03-07 13:10:00       102.2
	 
So, on March 7th Mumbai experienced the highest temperature for the year 2013.

[Back](index.html)

 