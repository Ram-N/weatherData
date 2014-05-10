---
layout: default
title: weatherData	
---

* [About the Package](#about)
* [Installing weatherData Package](#install)
    * [From CRAN](#cran)
    * [From Github](#github)
* [Basic Usage: Quick start](#quickstart)
* [Typical Workflow](#how-to-use-this-package)
* [Examples](#moreexamples)
* [Built-in Datasets] (#builtin)
* [Demo Shiny Application](#usecases)
* [Articles about the package](#articles)
* [Credits](#credits)
			
##Using WeatherData
  
  If you want to perform weather Analysis, but don't wish to do the data scraping yourself, you can consider using `weatherData`. Given a few parameters, it has functions that return the available data in a time-stamped data frame that is easy to work with.
  



###<a name="install"></a>  Two Installation Options 

You can install the version from CRAN, or you can try out the version hosted in Github. Github has the newer version, which is in development. This is where I try out the newer functions.

####<a name="cran"></a>Option 1: Install from CRAN

  <p>Install and Load the library</p>

	
    install.packages('weatherData')
    library(weatherData)
  

####<a name="github"></a>Option 2: Install from Github</h3>

  <p>The latest version of weatherData is on Github. (Note that this is the development version, and is usually ahead of what's on CRAN.) To install the development version of weatherData from github, use the <strong><code>devtools</code></strong> package.</p>

    install.packages("devtools")
    library("devtools")
    install_github("weatherData", "Ram-N")

  <p>Once the package has installed, load the library</p>

`library(weatherData)`

  <p>Note: Windows users must also first install
  <a href="http://cran.rstudio.com/bin/windows/Rtools/">Rtools</a>.</p>


###<a name="quickstart"></a>  Basic Usage: Quickstart

If you want to get started using the functions in the package right away, you can do so.

**Quickstart Example 1.** Start by getting the temperature data for a Location of interest for a particular date.

     getWeatherForDate("SEA", "2014-05-05")
	 
*Variations*
If you want detailed data:

     getWeatherForDate("SEA", "2014-05-05", opt_detailed=TRUE)

If you want detailed data for a range of dates:

     getWeatherForDate("SEA", "2014-04-01", end_date="2014-04-30")
	 #This will fetch a dataframe of temperature data for the month of April.
	 
**Quickstart Example 2.** Just get me everything for a whole year for a Location of interest.

     dfw_wx <- getWeatherForYear("DFW", 2013)

This is a just a very small sample of the functions. There are also a number of 'helper functions' to make life a little easier.


  <h1>
####<a name="how-to-use-this-package"></a>Using the package: Typical Workflow


Typically, in order to analyze the available weather data, you will need to decide on four parameters:

1. Location. (Which city, zipcode or weather station are you interested in)
2. Time Interval (Is this for 1 day, a sequence of dates, or a whole year or more)
3. Level of Detail: Is one record per day adequate? (If so, use summarized) If not, specify the `opt_detailed` option.
4. Which of the available columns are you interested in? (Temperature, Pressure, Wind, Humidity or all the available ones.)

In all the examples, it is assumed that you have loaded the library. You can do so by typing `library(weatherData).` 

####Step 1:
Find the `station id` for the location(s) that you are interested in. If you know the airport code (3 letters) you can try that.
Once you have the `station_id` and the date ranges, it is a simple matter to fetch the data.

Details around finding the weather station ID's can be [found here](getstation.html)

####Step 2:
Set the date range: `start_date="YYYY-MM-DD"` and `end_date="YYYY-MM-DD"` If you need data for just one day, then end_date doesn't have to be specified.

####Step 3:
If the default level of detail is sufficient, call one of the `getWeatherData()` functions, and assign the data frame being returned to it.

  `wx_df <- getWeatherForDate("SAN", "2011-08-26")`

##<a name="moreexamples"></a>Examples

* [Example 1: Using `getWeatherForYear()`](example_weatherYear.html) to compare the daily temperature differences for two cities. In this example, we get one year's worth of data for two cities, and plot the daily differences	
* [Example 2: Comparing Intra-day Humidity:](example_Humidity.html) This example illustrates how we go about getting one day's worth of custom data for several South East Asian cities, and how to plot the time series data obtained.

A few [more Detailed Examples](Examples2.html) of the functions in `weatherData` can be found in these [pages](Examples2.html).


####<a name="builtin"></a>Built-in Datasets
The package comes with a few pre-loaded datasets and those are available for trying out some basic analysis right away. More details about what is included and what each of those datasets contains can be [found here](builtin.html). That page also includes some sample code for using one of the datasets, `Mumbai2013`


### <a name="usecases"></a>weatherData Demo Application 

  <p><code>WeatherCompare</code> is <a href="http://spark.rstudio.com/ram/WeatherCompare/">a Shiny App</a> that uses the data brought over by weatherData and then summarized in various ways.</p>


###<a name="articles"></a>  Articles about weatherData

There have been a few articles written about the functions in this package. They might be useful to get a feel for use cases.

**Joe Rickert** of <code>Revolution Analytics</code> has written a <a href="http://blog.revolutionanalytics.com/2014/02/r-and-the-weather.html">blog post with a sample script that uses <code>weatherData</code></a>. Do check it out.

**Angela Hey**, a tech blogger for the **Mountain View Voice** wrote [an article about analyzing data with R](http://www.mv-voice.com/blogs/p/2014/04/17/analyze-data-yourself-with-r---a-fast-growing-language-for-statistics-forecasting-and-graphs), and used weatherData functions for her examples.  

Here's [a presentation](http://files.meetup.com/1225993/Ram_BARUG_weatherData.pptx) about the features in `weatherData` that are new to version 0.4. It was part of a short lightning I gave for the BARUG group. And here's [Joe Rickert's summary of the talks](http://blog.revolutionanalytics.com/2014/04/barug-talks-highlight-rs-diverse-applications.html).

###  <a name="credits" class="anchor" href="#credits"></a>Credits

The `weatherData` package has benefited from the suggestions of quite a number of weather analysts. Their feedback, suggestions
and bug reports have helped immensely. Detailed credits for their contributions can be found [here](credits.html).

Ram Narasimhan