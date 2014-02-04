\name{getWeatherData}
\alias{getWeatherData}
\title{Gets weather data for a single date}
\usage{
getWeatherData(station, date, station_type = "airportCode",
  opt_temperature_only = T, opt_compress_output = FALSE,
  opt_verbose = FALSE, opt_warnings = TRUE)
}
\arguments{
  \item{station}{is a valid 3-letter airport code or a
  valid Weather Station ID}

  \item{date}{is a valid string representing a date in the
  past (YYYY-MM-DD)}

  \item{station_type}{can be \code{airportCode} which is
  the default, or it can be \code{id} which is a
  weather-station ID}

  \item{opt_temperature_only}{Boolen flag to indicate only
  Temperature data is to be returned (default TRUE)}

  \item{opt_compress_output}{Boolean flag to indicate if a
  compressed output is preferred.  If this option is set to
  be TRUE, only every other record is returned}

  \item{opt_verbose}{Boolean flag to indicate if verbose
  output is desired}

  \item{opt_warnings}{Boolean flag to turn off warnings.
  Default value is TRUE, to keep the warnings on.}
}
\value{
A data frame with each row containing: \itemize{ \item Date
and Time stamp for the date specified \item Temperature
and/or other weather columns }

A data frame containing the Date & Time stamp and Weather
data columns
}
\description{
Given a valid station and a single date this function will
return a dataframe of time-stamped weather data
}

