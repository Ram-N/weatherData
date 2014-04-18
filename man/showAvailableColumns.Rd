\name{showAvailableColumns}
\alias{showAvailableColumns}
\title{Shows all the available Weather Data Columns}
\usage{
showAvailableColumns(station_id, start_date, end_date = NULL,
  station_type = "airportCode", opt_detailed = FALSE, opt_verbose = FALSE)
}
\arguments{
  \item{station_id}{is a valid 3-letter airport code or a
  valid Weather Station ID}

  \item{start_date}{string representing a date in the past
  ("YYYY-MM-DD")}

  \item{end_date}{string representing a date in the past
  ("YYYY-MM-DD"), and later than or equal to start_date.}

  \item{station_type}{can be \code{airportCode} which is
  the default, or it can be \code{id} which is a
  weather-station ID}

  \item{opt_detailed}{Boolen flag to indicate if detailed
  records for the station are desired. (default FALSE). By
  default only one records per date is returned.}

  \item{opt_verbose}{Boolean flag to indicate if verbose
  output is desired (default FALSE)}
}
\description{
This functons displays all the columns that are available
in the website, for the given station, and date range.
Useful when only a subset of the columns are desired. Those
can be specfied using the \code{custom_columns} vector.
}
\examples{
\dontrun{
showAvailableColumns("NRT", "2014-04-04")
}
}

