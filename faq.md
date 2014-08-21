---
layout: default
title: FAQ
---

[weatherData](index.html)

##Frequently Asked Questions


* [Q1: Why am I not getting the data I expect?](#notgetting)
* [Q2: Why can't I get data for a very large date range?](#largerange)


####<a name="notgetting"></a>Q1: Why am I not getting the data I expect?
Answer: The first place to check is the website. All `weatherData` functions eventually get data from a comma-separated file.
So the logical place to start is to go to that page (from your web browser) and check that the data is indeed there.

####<a name="largerange"></a>Q2: Why can't I get data for a very large date range?

Answer: If you try to get data for a date range much larger than 1 year, you won't get back the full data.
For example, if you try using `getSummarizedWeather` you will get only around 400 rows. This seems to be a limit imposed by the weather underground site.

**Workaround**: You can get it in multiple chunks. Say one year at a time. Then you can combine them all into one giant dataframe, using `rbind()`. One bit of caution: Sometimes the names of the different dataframes change. You have to first convert them all to one common set of column names before `rbind` can work. (Use with caution!)


[Back](index.html)

