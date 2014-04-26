---
layout: default
title: Built-in Datasets
---
 
 
 <h3>
 <a name="built-in-datasets" class="anchor" href="#built-in-datasets"><span class="octicon octicon-link"></span></a>Built-in DataSets</h3>

`data(London2013)`

This is a data frame of Ambient temperature data, extracted
 from Weather Undergound. Each row has two entries (columns). 
 
 - The Timestamp (YYYY-MM-DD HH:MM:SS) and the
 - TemperatureF (in degrees F)
 
####Other Datasets Available
 * `Mumbai2013`		Data - Ambient Temperature for the City of Mumbai, India for all of 2013
 * `NewYork2013`	Data - Ambient Temperature for New York City for all of 2013
 * `SFO2012`		Data - Ambient Temperature for the City of San Francisco for all of 2012
 * `SFO2013`		Data - Ambient Temperature for the City of San Francisco for all of 2013
 
####Example of Using the Built-in Data Frame	
<h6>Say you wanted to find out the Date and Time in 2013 when it was hottest in Mumbai</h6>
 
We can use the built-in Dataset for this:
 
 <pre>   > max(Mumbai2013$Temperature)
	 [1] 102.2
	 
	 > which.max(Mumbai2013$Temperature)
	 [1] 3212 
	 
	 > Mumbai2013[which.max(Mumbai2013$Temperature), ]
                         Time Temperature
     3212 2013-03-07 13:10:00       102.2
	 
</pre> 

[Back](index.html)

 