\name{FetchStationWeatherForDateRange}
\alias{FetchStationWeatherForDateRange}
\title{Getting data for full date-range}
\usage{
FetchStationWeatherForDateRange(station, station.type, start.date, end.date)
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
\author{
Ram Narasimhan
}

