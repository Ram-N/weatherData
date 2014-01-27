\name{getWeatherForDateRange}
\alias{getWeatherForDateRange}
\title{Getting data for full date-range}
\usage{
getWeatherForDateRange(station, station.type, start_date, end_date)
}
\arguments{
  \item{station}{is a valid 3-letter airport code or a
  valid Weather Station ID}

  \item{start_date}{is a valid string representing a date
  in the past (YYYY-MM-DD, all numeric)}

  \item{end_date}{is a a valid string representing a date
  in the past (YYYY-MM-DD, all numeric) and is greater than
  start_date}

  \item{station.type}{= "airportCode" (3-letter airport
  code) or "ID" (Wx call Sign)}
}
\description{
Getting data for full date-range
}
\details{
For each day in the date range, this function fetches
Weather Data Internally, it makes multiple calls to
getSingleDayWeather
}

