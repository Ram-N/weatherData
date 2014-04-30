#' @title Data - Ambient Temperature for the City of London for all of 2013
#'
#' @description This is a data frame of Ambient temperature data, extracted from Weather Undergound.
#' Each row has two entries (columns). The Timestamp (YYYY-MM-DD HH:MM:SS) and the Temperature (in degrees F)
#'
#' @author Ram Narasimhan \email{ramnarasimhan@@gmail.com}
#' @name London2013
#' @docType data
#' @usage data(London2013)
#' @references 
#' \url{http://www.wunderground.com/history/airport/EGLL/2013/1/1/DailyHistory.html?format=1}
#' @keywords data
#' 
NULL

#' @title Data - Ambient Temperature for the City of Mumbai, India for all of 2013
#'
#' @description This is a data frame of Ambient temperature data, extracted from Weather Undergound.
#' Each row has two entries (columns). The Timestamp (YYYY-MM-DD HH:MM:SS) and the Temperature (in degrees F)
#'
#' @author Ram Narasimhan \email{ramnarasimhan@@gmail.com}
#' @name Mumbai2013
#' @docType data
#' @usage data(Mumbai2013)
#' @references 
#' \url{http://www.wunderground.com/history/airport/VABB/2014/1/1/DailyHistory.html?format=1}
#' @keywords data
#' 
NULL

#' @title Data - Ambient Temperature for New York City for all of 2013
#'
#' @description This is a data frame of Ambient temperature data, extracted from Weather Undergound.
#' Each row has two entries (columns). The Timestamp (YYYY-MM-DD HH:MM:SS) and the Temperature (in degrees F)
#'
#' @author Ram Narasimhan \email{ramnarasimhan@@gmail.com}
#' @name NewYork2013
#' @docType data
#' @usage data(NewYork2013)
#' @references 
#' \url{http://www.wunderground.com/history/airport/KLGA/2013/1/1/DailyHistory.html?format=1}
#' @keywords data
#' 
NULL

#' @title Data - Summarized Daily Temperature for the City of San Francisco for all of 2013
#'
#' @description This is a data frame of Ambient temperature data, extracted from Weather Undergound.
#' Each row has four columns. The Timestamp (YYYY-MM-DD HH:MM:SS) and three Temperature Columns: Daily Max, Mean and Min (in degrees F)
#' In comparison with the \code{SFO2013} dataset which has 9507 rows, this dataset has exactly
#' 365 rows, one for each day in 2013.
#' @author Ram Narasimhan \email{ramnarasimhan@@gmail.com}
#' @name SFO2013Summarized
#' @docType data
#' @usage data(SFO2013Summarized)
#' @references 
#' \url{http://www.wunderground.com/history/airport/SFO/2013/1/1/CustomHistory.html?dayend=31&monthend=12&yearend=2013&req_city=NA&req_state=NA&req_statename=NA&format=1}
#' @keywords data
#' 
NULL

#' @title Data - Ambient Temperature for the City of San Francisco for all of 2013
#'
#' @description This is a data frame of Ambient temperature data, extracted from Weather Undergound.
#' Each row has two entries (columns). The Timestamp (YYYY-MM-DD HH:MM:SS) and the Temperature (in degrees F)
#'
#' @author Ram Narasimhan \email{ramnarasimhan@@gmail.com}
#' @name SFO2013
#' @docType data
#' @usage data(SFO2013)
#' @references 
#' \url{http://www.wunderground.com/history/airport/KSFO/2013/1/1/DailyHistory.html?format=1}
#' @keywords data
#' 
NULL

#' @title Data - Ambient Temperature for the City of San Francisco for all of 2012
#'
#' @description This is a data frame of Ambient temperature data, extracted from Weather Undergound.
#' Each row has two entries (columns). The Timestamp (YYYY-MM-DD HH:MM:SS) and the Temperature (in degrees F)
#'
#' @author Ram Narasimhan \email{ramnarasimhan@@gmail.com}
#' @name SFO2012
#' @docType data
#' @usage data(SFO2012)
#' @references 
#' \url{http://www.wunderground.com/history/airport/KSFO/2012/1/1/DailyHistory.html?format=1}
#' @keywords data
#' 
NULL


#' @title Data - US Weather Stations ID's 
#' 
#' @description This is a data frame of the 1602 stations in Weather Underground's
#'  database. The 4-letter "airportCode" is used by functions
#'  to check and get the weather data.
#' 
#'
#' @author Ram Narasimhan \email{ramnarasimhan@@gmail.com}
#' @name USAirportWeatherStations
#' @docType data
#' @usage data(USAirportWeatherStations)
#' @references 
#' \url{http://www.wunderground.com/about/faq/US_cities.asp}
#' @keywords data
#' 
NULL

#' @title Data - International Weather Stations
#' @description This is a data frame of the 1602 stations in Weather Underground's
#'  database. The 4-letter "ICAO" is used by the functions in this package
#'  to check and get the weather data. Note that not all the stations
#'  have weather data.
#' @author Ram Narasimhan \email{ramnarasimhan@@gmail.com}
#' @name IntlWxStations
#' @docType data
#' @usage data(IntlWxStations)
#' @references This data frame has been created by 
#' \url{http://weather.rap.ucar.edu/surface/stations.txt}
#' maintained by Greg Thompson of NCAR.
#' @keywords data
#' 
NULL

