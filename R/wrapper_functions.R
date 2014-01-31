#' @title Check if WeatherUnderground has Data for given station and date
#' 
#' @description Use this function to check if data is available for station and date
#'  If the station code or the date in invalid, function will return 0 
#'  
#' @param station is a valid 3-letter airport code or a valid Weather Station ID
#' @param check_date is a a valid string representing a date in the past (string "YYYY-MM-DD")
#' @param station_type is either \code{airportCode} or \code{id}
#' @references For a list of valid Weather Stations, try this format
#'  \url{http://www.wunderground.com/weatherstation/ListStations.asp?selectedCountry=United+States}
#'  and replace with your country of interest
#' @return 1 if the Station did have weather records, 0 if nothing was found  
#' @export 
checkStnDataForDate<- function (station, 
                                   check_date, 
                                   station_type="airportCode"                                
                                  ) {  
  df <- getWeatherForDate(station, check_date, station_type, 
                                   opt_temperature_only=T, opt_compress_output=T, 
                                   opt_verbose=T)
  
    
  message(sprintf("Checking Data Availability For %s", station))
  if (!is.null(df)) {  
    message(sprintf("Found %d records for %s", nrow(df), check_date))
    message("Data is Available")
    return(1)
  }  else {
    message("Data is Not Available")
    return(0) #nothing found
  }
}


#' @title Quick Check to see if WeatherUnderground has Weather Data for given station
#' 
#' @description Before we attempt to fetch the data for a big time interval of dates, this 
#'  function is useful to see if the data even exists.
#'  @details This functions checks for just the first and the last date in the interval
#'    Not the days in between
#' @param station is a valid 3-letter airport code or a valid Weather Station ID
#' @param station_type is either \code{airportCode} or \code{id}
#' @param start_date is a valid string representing a date in the past (YYYY-MM-DD, all numeric)
#' @param end_date is a a valid string representing a date in the past (YYYY-MM-DD, all numeric) and is greater than start_date
#' 
#' @return 1 if the Station did have weather records, 0 if nothing was found  

#' @export 
checkStnDataForDateRange<- function (station, 
                                     start_date, 
                                     end_date,
                                     station_type="airportCode"                                
) {  
  df_start <- getWeatherForDate(station, start_date, station_type, 
                                  opt_temperature_only=T, opt_compress_output=T, 
                                  opt_verbose=T)
  
  df_end <- getWeatherForDate(station, end_date, station_type,  opt_temperature_only=T, 
                                opt_compress_output=T, opt_verbose=T)
  
  st_row = nrow(df_start) #takes on a value of NULL if station has no data
  en_row = nrow(df_end)
  
  message(sprintf("Checking Data Availability For %s", station))
  if (!is.null(df_start)) {  
    message(sprintf("Found %d records for %s", st_row, start_date))
  }    else {
    message(sprintf("Found 0 records for %s", start_date))
  }
  
  if (!is.null(df_end)) {  
    message(sprintf("Found %d records for %s\n", en_row, end_date))
  }    else {
    message(sprintf("Found 0records for %s", end_date))
  }
  
  if (is.integer(st_row) && is.integer(en_row))
  {
    message("Data is Available for the interval.")
    return(1)
  }
  else {
    message("Data is Not Available")
    return(0) #nothing found
  }
}





#'  Getting data for a range of dates 
#'   
#' @description This function will return a (fairly large) data frame. If you are going 
#'  to be using this data for future analysis, you can store the results in a CSV file
#'   by setting \code{opt_write_to_file} to be TRUE
#' @details For each day in the date range, this function fetches Weather Data.
#'  Internally, it makes multiple calls to \code{getWeatherForDate}.
#' 
#' @param station is a valid 3- or 4-letter Airport code or a valid Weather Station ID
#'  (example: "BUF", "ORD", "VABB" for Mumbai).
#'  Valid Weather Station "id" values: "KFLMIAMI75" or "IMOSCOWO2" You can look these up
#'   at wunderground.com
#' @param start_date is a valid string representing a date in the past (YYYY-MM-DD, all numeric)
#' @param end_date is a a valid string representing a date in the past (YYYY-MM-DD, all numeric) and is greater than start_date  
#' @param station_type = "airportCode" (3-letter airport code) or "ID" (Wx call Sign)
#' @param opt_write_to_file If TRUE, the resulting dataframe will be stored in a CSV file. 
#'  Default is FALSE
#' @references For a list of valid Weather Stations, try this format
#'  \url{http://www.wunderground.com/weatherstation/ListStations.asp?selectedCountry=United+States}
#'  and replace with your country of interest
#' @return A data frame with each row containing: \itemize{
#' \item Date and Time stamp (for each date specified)
#' \item Temperature and/or other weather columns sought
#' }

#' @export
getWeatherForDateRange <- function(station, 
                                start_date, 
                                end_date,
                                station_type="airportCode",
                                opt_write_to_file = FALSE
                                ) {  
  validity = checkStnDataForDateRange(station,  start_date, end_date, station_type)
  if (validity==0){
    warning(paste("Station data not available.", station, start_date, "to", "end_date"))
    return(NULL) #returning a NULL to signal no data
  }
  
  date.range <- seq.Date(from=as.Date(start_date), to=as.Date(end_date), by='1 day')
  message("Begin getting Daily Data for ", station)
  # pre-allocate list
  l <- vector(mode='list', length=length(date.range))
  
  # loop over dates, and fetch data
  for(i in seq_along(date.range))
  {
    l[[i]] <- getWeatherForDate(station,  date.range[i], station_type)
    message(paste(station, i, date.range[i], ":",  nrow(l[[i]]), "Rows" ))
  }
  
  # stack elements of list into DF, filling missing columns with NA
  d <- ldply(l)
    
  if(opt_write_to_file) {
    outFileName <- paste0(station,"_",start_date,"_",end_date)
    outFileName <- paste(outFileName, "csv","gz", sep=".")
    
    # save to CSV
    write.csv(d, file=gzfile(outFileName), row.names=FALSE)
    message(paste("wrote:", outFileName, "to", getwd()))    
  }
  return(d)
}


#' Get the latest recorded temperature for a location
#' 
#' @description A wrapper for getWeatherForDate(), it returns the last
#'  record in the web page. Uses Sys.Date() to get current time. 
#'
#' @param station is a valid 3- or 4-letter Airport code or a valid Weather Station ID
#'  (example: "BUF", "ORD", "VABB" for Mumbai).
#'  Valid Weather Station "id" values: "KFLMIAMI75" or "IMOSCOWO2" You can look these up
#'   at wunderground.com
#' @return A one row data frame containing: \itemize{
#' \item Date and Time stamp (for when the latest temperature reading was recorded)
#' \item Temperature for the station in Farenheit (or Celcius)
#' }
#' @references For a list of valid Weather Stations, try this format
#'  \url{http://www.wunderground.com/weatherstation/ListStations.asp?selectedCountry=United+States}
#'  and replace with your country of interest
#' 
#' @examples getCurrentTemperature(station ="HNL")
#' @export
getCurrentTemperature <- function(station){  
  #Try with tomorrow's date first, in case location is ahead in timezone
  #We expect this to fail if the date is in the future. That's why
  # the warnings are FALSE.
  
  temp.df <- getWeatherForDate(station, Sys.Date()+1,  
                                 opt_warnings=FALSE)
  
  #If the second call also fails, we want to be warned, so opt_warnings=T
  #The only reason this can fail is if the station is invalid
  if(is.null(temp.df))  temp.df <- getWeatherForDate(station, Sys.Date()
                                                       ,  opt_warnings=TRUE)  
  temp.df[nrow(temp.df), ]
}


#' Gets the Weather Station code for a location (in the US)
#'
#' This function goes through the USAirportWeatherStations dataset
#' and looks for matches. Usually, the 4 letter airportCode is what you are after.
#' 
#'
#'@param stationName String that you want to get the weatherStation code for
#'@param state Two-letter String with state name abbreviation. Ex. "AK" for Alaska 
#' @return A one row data frame containing: \itemize{
#' \item A string of Station Name that matched
#' \item two-letter US state abbreviation
#' \item The 4-letter weather station ID. (This is the string you use when 
#'  calling \code{getWeatherForDate()})
#' }
#'@examples getStationCode("Denver")
#'@export
getStationCode <- function(stationName, state="XX"){

  if(state != "XX"){
    state_matches <- grep(pattern=state,
                          USAirportWeatherStations$State, 
                          ignore.case=TRUE, value=FALSE)  
  }
  stn_matches <- grep(pattern=stationName,
                      USAirportWeatherStations$Station, 
                      ignore.case=TRUE, value=FALSE)
  
  if(state != "XX"){
    intersection <- which(state_matches %in% stn_matches)
    if(length(intersection)) {
      both_matches <- state_matches[intersection]
      stn2 <-  USAirportWeatherStations[both_matches, c("Station", "State", "airportCode")]  
      return(stn2)
    } else{
      message("Could not match both StationName and State")
    }
  }
  
  if(length(stn_matches)){
    USAirportWeatherStations[stn_matches, c("Station", "State", "airportCode")]  
  }
#   if(length(state_matches)){
#   stn2 <-  USAirportWeatherStations[state_matches, c("Station", "State", "airportCode")]  
#   }
#   
#   rbind(stn1, stn2)
    
}

