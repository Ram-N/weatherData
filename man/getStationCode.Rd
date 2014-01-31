\name{getStationCode}
\alias{getStationCode}
\title{Gets the Weather Station code for a location (in the US)}
\usage{
getStationCode(stationName, state = "XX")
}
\arguments{
  \item{stationName}{String that you want to get the
  weatherStation code for}

  \item{state}{Two-letter String with state name
  abbreviation. Ex. "AK" for Alaska}
}
\value{
A one row data frame containing: \itemize{ \item A string
of Station Name that matched \item two-letter US state
abbreviation \item The 4-letter weather station ID. (This
is the string you use when calling
\code{getWeatherForDate()}) }
}
\description{
This function goes through the USAirportWeatherStations
dataset and looks for matches. Usually, the 4 letter
airportCode is what you are after.
}
\examples{
getStationCode("Denver")
}

