\name{getSingleDayWeather}
\alias{getSingleDayWeather}
\title{This function gets weather data, given a valid station and a single date}
\usage{
getSingleDayWeather(station, date, station_type = "airportCode",
  opt_temperature_only = T, opt.compress.output = FALSE,
  opt_verbose = FALSE)
}
\arguments{
  \item{station}{is a valid 3-letter airport code or a
  valid Weather Station ID}

  \item{date}{is a valid string representing a date in the
  past (YYYY-MM-DD)}

  \item{station_type}{can be \code{airportCode} which is
  the default, or it can be \code{id} which is a
  weather-station ID}

  \item{opt_temperature_only}{is a flag to indicate only
  Temperature data is to be returned (default TRUE)}

  \item{opt.compress.output}{flag to indicate if a
  compressed output is preferred. If TRUE, only every other
  record is returned.}

  \item{opt_verbose}{A Flag to indicate if verbose output
  is desired}
}
\description{
TODO: Error checking for valid station name, date,
station_type
}

