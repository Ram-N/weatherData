\name{getWeatherForDate}
\alias{getWeatherForDate}
\title{Getting data for a range of dates}
\usage{
getWeatherForDate(station_id, start_date, end_date = NULL,
  daily_min = FALSE, daily_max = FALSE, station_type = "airportCode",
  opt_write_to_file = FALSE)
}
\arguments{
  \item{station_id}{is a valid 3- or 4-letter Airport code
  or a valid Weather Station ID (example: "BUF", "ORD",
  "VABB" for Mumbai).  Valid Weather Station "id" values:
  "KFLMIAMI75" or "IMOSCOWO2" You can look these up at
  wunderground.com}

  \item{start_date}{is a valid string representing a date
  in the past (YYYY-MM-DD, all numeric)}

  \item{end_date}{(optional) If an interval is to be
  specified, end_date is a a valid string representing a
  date in the past (YYYY-MM-DD, all numeric) and greater
  than start_date}

  \item{daily_min}{A boolean indicating if only the Minimum
  Temperatures are desired}

  \item{daily_max}{A boolean indicating if only the Maximum
  Temperatures are desired}

  \item{station_type}{= "airportCode" (3- or 4-letter
  airport code) or "ID" (Wx call Sign)}

  \item{opt_write_to_file}{If TRUE, the resulting dataframe
  will be stored in a CSV file.  Default is FALSE}
}
\value{
A data frame with each row containing: \itemize{ \item Date
and Time stamp (for each date specified) \item Temperature
and/or other weather columns sought }
}
\description{
This function will return a (fairly large) data frame. If
you are going to be using this data for future analysis,
you can store the results in a CSV file by setting
\code{opt_write_to_file} to be TRUE
}
\details{
For each day in the date range, this function fetches
Weather Data.  Internally, it makes multiple calls to
\code{getWeatherData}.
}
\examples{
\dontrun{
dat <- getWeatherForDate("PHNL", "2013-08-10", 2013-08-31")
}
}
\references{
For a list of valid Weather Stations, try this format
\url{http://www.wunderground.com/weatherstation/ListStations.asp?selectedCountry=United+States}
and replace with your country of interest
}

