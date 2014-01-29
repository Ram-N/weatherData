\name{checkStnDataForDateRange}
\alias{checkStnDataForDateRange}
\title{Quick Check to see if WeatherUnderground has Weather Data for given station}
\usage{
checkStnDataForDateRange(station, start_date, end_date,
  station_type = "airportCode")
}
\arguments{
  \item{station}{is a valid 3-letter airport code or a
  valid Weather Station ID}

  \item{station_type}{is either \code{airportCode} or
  \code{id}}

  \item{start_date}{is a valid string representing a date
  in the past (YYYY-MM-DD, all numeric)}

  \item{end_date}{is a a valid string representing a date
  in the past (YYYY-MM-DD, all numeric) and is greater than
  start_date}
}
\description{
Before we attempt to fetch the data for a big time interval
of dates, this function is useful to see if the data even
exists.
}
\details{
This functions checks for just the first and the last date
in the interval Not the days in between
}

