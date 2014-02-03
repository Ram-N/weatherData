\name{getCurrentTemperature}
\alias{getCurrentTemperature}
\title{Get the latest recorded temperature for a location}
\usage{
  getCurrentTemperature(station)
}
\arguments{
  \item{station}{is a valid 3- or 4-letter Airport code or
  a valid Weather Station ID (example: "BUF", "ORD", "VABB"
  for Mumbai).  Valid Weather Station "id" values:
  "KFLMIAMI75" or "IMOSCOWO2" You can look these up at
  wunderground.com}
}
\value{
  A one row data frame containing: \itemize{ \item Date and
  Time stamp (for when the latest temperature reading was
  recorded) \item Temperature for the station in Farenheit
  (or Celcius) }
}
\description{
  A wrapper for getWeatherData(), it returns the last
  record in the web page. Uses Sys.Date() to get current
  time.
}
\examples{
getCurrentTemperature(station ="HNL")
}
\references{
  For a list of valid Weather Stations, try this format
  \url{http://www.wunderground.com/weatherstation/ListStations.asp?selectedCountry=United+States}
  and replace with your country of interest
}

