\name{checkStnDataForDate}
\alias{checkStnDataForDate}
\title{Check if WeatherUnderground has Data for given station and date}
\usage{
checkStnDataForDate(station, check_date, station_type = "airportCode")
}
\arguments{
  \item{station}{is a valid 3-letter airport code or a
  valid Weather Station ID}

  \item{check_date}{is a a valid string representing a date
  in the past (string "YYYY-MM-DD")}

  \item{station_type}{is either \code{airportCode} or
  \code{id}}
}
\value{
1 if the Station did have weather records, 0 if nothing was
found
}
\description{
Use this function to check if data is available for station
and date If the station code or the date in invalid,
function will return 0
}
\references{
For a list of valid Weather Stations, try this format
\url{http://www.wunderground.com/weatherstation/ListStations.asp?selectedCountry=United+States}
and replace with your country of interest
}

