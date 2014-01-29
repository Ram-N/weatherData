\name{weatherData-package}
\alias{weatherData-package}
\alias{weatherData}
\docType{package}
\title{
Get Historical Weather & Temperature data from the Web
}
\description{
The package has functions that can fetch weather data.
These functions don't use APIs. They rely on reading URL's instead.
Given a valid city and a date (or date range), the functions in 
weatherData can fetch them as a nice R data frame. 
These functions are useful for anyone interested in doing weather data analysis using R.
}
\details{
\tabular{ll}{
Package: \tab weatherData\cr
Type: \tab Package\cr
Version: \tab 0.1\cr
Date: \tab 2014-01-18\cr
License: \tab GPL\cr
}
 An overview of how to use the package, including the most important
 functions
}
\author{
Ram Narasimhan

Maintainer: Ram Narasimhan <ramnarasimhan@gmail.com>
}
\keyword{ package }
\examples{
getSingleDayWeather("LAX", "2013-01-01")
checkStnDataForDateRange("BWI", "2013-12-13", "2014-01-01", "airportCode")
}
