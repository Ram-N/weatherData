---
layout: default
title: FAQ
---

[weatherData](index.html)

##Frequently Asked Questions


* [Q1: Why am I not getting the data I expect?](#notgetting)
* [Q2: Why can't I get data for a very large date range?](#largerange)
* [Q3: Can I get data from a personal Weather Station?](#personalstation)


####<a name="notgetting"></a>Q1: Why am I not getting the data I expect?
Answer: The first place to check is the website. All `weatherData` functions eventually get data from a comma-separated file.
So the logical place to start is to go to that page (from your web browser) and check that the data is indeed there.

####<a name="largerange"></a>Q2: Why can't I get data for a very large date range?

Answer: If you try to get data for a date range much larger than 1 year, you won't get back the full data.
For example, if you try using `getSummarizedWeather` you will get only around 400 rows. This seems to be a limit imposed by the weather underground site.

**Workaround**: You can get it in multiple chunks. Say one year at a time. Then you can combine them all into one giant dataframe, using `rbind()`. One bit of caution: Sometimes the names of the different dataframes change. You have to first convert them all to one common set of column names before `rbind` can work. (Use with caution!)

####<a name="personalstation"></a>Q3: Can I get data from a personal Weather Station?

**Note: This feature is now available only from Github** Not yet on CRAN.

Answer: If you specify *station_type="id"* you can fetch data from personal weather stations that Weather Underground supports. There are 1000s of such stations all over the world. Get the station_id by checking the weather underground website.

Then do the following:
   library(devtools)
   install_github("weatherData", "Ram-N")
   library(weatherData)

   #important to set the station_type to be "id"
   getDetailedWeather("ISKHALBR2", "2013-08-23", station_type="id")

   #get specific columns
   getDetailedWeather("ISKHALBR2", "2013-08-23", station_type="id",
                     opt_custom_columns=T,
                     custom_columns = c(3,4))
  



[Back to Index](index.html)

