#' @title Check if WeatherUnderground has Data for given station and date
#' 
#' @description Use this function to check if data is available for station and date
#'  If the station code or the date is invalid, function will return 0 
#'  
#' @param station_id is a valid airport code or a valid Weather Station ID
#' @param check_date is a a valid string representing a date in the past (string "YYYY-MM-DD")
#' @param station_type is either \code{airportCode} or \code{id}
#' @references For a list of valid Weather Stations, try this format
#'  \url{http://www.wunderground.com/weatherstation/ListStations.asp?selectedCountry=United+States}
#'  and replace with your country of interest
#' @return 1 if the station does have weather records for input date, 
#'  0 if no records were found  
#' @export 
checkDataAvailability <- function (station_id, 
                                   check_date, 
                                   station_type="airportCode"                                
                                  ) {  
  df <- getWeatherData(station_id, 
                          check_date, 
                          station_type, 
                          opt_temperature_only=T, 
                          opt_compress_output=T, 
                          opt_verbose=T)
  
    
  message(sprintf("Checking Data Availability For %s", station_id))
  if (!is.null(df)) {
    message(sprintf("Found Records for %s", check_date))
    message("Data is Available")
    return(1)
  }  else {
    message("Data is Not Available")
    return(0) #nothing found
  }
}


#' @title Quick Check to see if WeatherUnderground has Weather Data for given station
#'  for a range of dates
#' @description Before we attempt to fetch the data for a big time interval of dates, this 
#'  function is useful to see if the data even exists.
#'  @details This functions checks for just the first and the last date in the interval,
#'    not the days in between
#' @param station_id is a valid 3-letter airport code or a valid Weather Station ID
#' @param station_type is either \code{airportCode} or \code{id}
#' @param start_date is a valid string representing a date in the past (YYYY-MM-DD, all numeric)
#' @param end_date is a a valid string representing a date in the past (YYYY-MM-DD, all numeric) and is greater than start_date
#' 
#' @return 1 if the Station did have weather records, 0 if nothing was found  

#' @export 
checkDataAvailabilityForDateRange<- function (station_id, 
                                     start_date, 
                                     end_date,
                                     station_type="airportCode"                                
) {  
  df_start <- getWeatherData(station_id, start_date, station_type, 
                                  opt_temperature_only=T, opt_compress_output=T, 
                                  opt_verbose=T)
  
  df_end <- getWeatherData(station_id, end_date, station_type,  opt_temperature_only=T, 
                                opt_compress_output=T, opt_verbose=T)
  
  st_row = nrow(df_start) #takes on a value of NULL if station has no data
  en_row = nrow(df_end)
  
  message(sprintf("Checking Data Availability For %s", station_id))
  if (!is.null(df_start)) {  
    message(sprintf("Found %d records for %s", st_row, start_date))
  }    else {
    message(sprintf("Found 0 records for %s", start_date))
  }
  
  if (!is.null(df_end)) {  
    message(sprintf("Found %d records for %s\n", en_row, end_date))
  }    else {
    message(sprintf("Found 0 records for %s", end_date))
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
#'  Internally, it makes multiple calls to \code{getWeatherData}.
#' 
#' @param station_id is a valid 3- or 4-letter Airport code or a valid Weather Station ID
#'  (example: "BUF", "ORD", "VABB" for Mumbai).
#'  Valid Weather Station "id" values: "KFLMIAMI75" or "IMOSCOWO2" You can look these up
#'   at wunderground.com
#' @param start_date is a valid string representing a date in the past (YYYY-MM-DD, all numeric)
#' @param end_date is a a valid string representing a date in the past (YYYY-MM-DD, all numeric) and is greater than start_date  
#' @param station_type = "airportCode" (3- or 4-letter airport code) or "ID" (Wx call Sign)
#' @param opt_write_to_file If TRUE, the resulting dataframe will be stored in a CSV file. 
#'  Default is FALSE
#' @references For a list of valid Weather Stations, try this format
#'  \url{http://www.wunderground.com/weatherstation/ListStations.asp?selectedCountry=United+States}
#'  and replace with your country of interest
#' @return A data frame with each row containing: \itemize{
#' \item Date and Time stamp (for each date specified)
#' \item Temperature and/or other weather columns sought
#' }
#'@examples
#'\dontrun{
#' dat <- getWeatherForDate("PHNL", "2013-08-10", 2013-08-31")
#'}
#' @export
getWeatherForDate <- function(station_id, 
                              start_date, 
                              end_date =NULL,
                              daily_min=NULL,
                              daily_max=NULL,                              
                              station_type="airportCode",
                              opt_write_to_file = FALSE
                                ) {  
  if(is.null(end_date)) {
    valid <- checkDataAvailability(station_id, start_date, station_type)
    if(valid){
      d <- getWeatherData(station_id, 
                          start_date,
                          station_type)
      outFileName <- paste0(station_id,"_",start_date)
      outFileName <- paste(outFileName, "csv","gz", sep=".")
      
    }
  } else {
    validity <- checkDataAvailabilityForDateRange(station_id,  start_date, end_date, station_type)
    if (validity==0){
      warning(paste("Station data not available.", station_id, start_date, "to", "end_date"))
      return(NULL) #returning a NULL to signal no data
    }
    
    date.range <- seq.Date(from=as.Date(start_date), to=as.Date(end_date), by='1 day')
    message("Begin getting Daily Data for ", station_id)
    # pre-allocate list
    l <- vector(mode='list', length=length(date.range))
    
    # loop over dates, and fetch data
    for(i in seq_along(date.range))
    {
      single_day_df <- getWeatherData(station_id,  date.range[i], station_type)
      message(paste(station_id, i, date.range[i], ":",  nrow(l[[i]]), "Rows" ))
      if(daily_min | daily_max) {
        l[[i]] <- keepOnlyMinMax(single_day_df, daily_min, daily_max)
      } else{ #store the full day's dframe
        l[[i]] <- single_day_df        
      }
    }
    
    # stack elements of list into DF, filling missing columns with NA
    d <- ldply(l)
    outFileName <- paste0(station_id,"_",start_date,"_",end_date)
    outFileName <- paste(outFileName, "csv","gz", sep=".")
  }    
  
  if(opt_write_to_file) {
    write.csv(d, file=gzfile(outFileName), row.names=FALSE)
    message(paste("wrote:", outFileName, "to", getwd()))    
  }  
  
  return(d)
}


#'  Get weather data for one full year
#'  
#' @description Function will return a data frame with all the records
#'   for a given station_id and year. If the current year is supplied,
#'   it will returns records until the current Sys.Date() ("today")
#'   
#' @details Note that this function is a light wrapper for getWeatherForDate
#'    with the two end dates being Jan-01 and Dec-31 of the given year.
#'   
#' @description This function will return a (fairly large) data frame. If you are going 
#'  to be using this data for future analysis, you can store the results in a CSV file
#'   by setting \code{opt_write_to_file} to be TRUE
#' @details For each day in the date range, this function fetches Weather Data.
#'  Internally, it makes multiple calls to \code{getWeatherData}.
#'  
#' @param station_id is a valid 3- or 4-letter Airport code or a valid Weather Station ID
#'  (example: "BUF", "ORD", "VABB" for Mumbai).
#'  Valid Weather Station "id" values: "KFLMIAMI75" or "IMOSCOWO2" You can look these up
#'   at wunderground.com
#' @param year is a valid year in the past (numeric, YYYY format)
#' @param station_type = "airportCode" (3 or 4 letter airport code) or "ID" (Wx call Sign)
#' @param opt_write_to_file If TRUE, the resulting dataframe will be stored in a CSV file. 
#'  Default is FALSE
#' @references For a list of valid Weather Stations, try this format
#'  \url{http://www.wunderground.com/weatherstation/ListStations.asp?selectedCountry=United+States}
#'  and replace with your country of interest
#' @return A data frame with each row containing: \itemize{
#' \item Date and Time stamp (for each date specified)
#' \item Temperature and/or other weather columns sought
#' }
#'@examples
#'\dontrun{
#' dat <- getWeatherForYear("KLGA", 2013)
#'}
#' @export
getWeatherForYear <- function(station_id,
                              year,
                              station_type="airportCode",
                              opt_write_to_file = FALSE) {
  
  if(!validYear(year)){   #check if year is valid
    warning("Year argument is invalid. Please provide a valid 4-digit 
            year (numeric)")
    return(NULL)
  } 
  
  if(year == (1900 + as.POSIXlt(Sys.Date())$year)) { #current Year. Just go until current date
    last_day <-  Sys.Date()   
  } else{
    last_day <- paste0(year,"-12-31")
  }
  first_day <- paste0(year,"-01-01")
  
  getWeatherForDate(station_id, first_day, last_day)  
}



#' Get the latest recorded temperature for a location
#' 
#' @description A wrapper for getWeatherData(), it returns the last
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
  
  temp.df <- getWeatherData(station, Sys.Date()+1,  
                                 opt_warnings=FALSE)
  
  #If the second call also fails, we want to be warned, so opt_warnings=T
  #The only reason this can fail is if the station is invalid
  if(is.null(temp.df))  temp.df <- getWeatherData(station, Sys.Date()
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
#'@param region A qualifier about the station's location.
#' It could be a continent or a country.
#' If in the US, region is a two-letter state abbreviation. Ex. "AK" for Alaska 
#' @return A one row data frame containing: \itemize{
#' \item A string of Station Name that matched
#' \item the region. (two-letter state abbreviation if in the US)
#' \item The 4-letter weather station ID. (This is the string you use when 
#'  calling \code{getWeatherData()})
#' }
#' 
#' @references For a world-wide list of possible stations, be sure to look at
#' \url{http://weather.rap.ucar.edu/surface/stations.txt} The ICAO (4-letter
#' code is what needs to be input to \code{getWeatherData()})
#' 
#'@examples getStationCode("Denver")
#'@export
getStationCode <- function(stationName, region=NULL){

  stn2 <- NULL; us_stns <- NULL
  intl_stn2 <- NULL; i_stns <- NULL
  if(!is.null(region)){
    region_matches <- grep(pattern=region,
                          USAirportWeatherStations$State, 
                          ignore.case=TRUE, value=FALSE)  
    
    iRegion_matches <- grep(pattern=region,
                            IntlWxStations[,1],
                           ignore.case=TRUE, value=FALSE)  
    
    
  }
  stn_matches <- grep(pattern=stationName,
                      USAirportWeatherStations$Station, 
                      ignore.case=TRUE, value=FALSE)
  iName_matches <- grep(pattern=stationName,
                        IntlWxStations[, 1], 
                        ignore.case=TRUE,
                        value=FALSE)
  
  
  if(!is.null(region)){
    intl_section <- which(iName_matches %in% iRegion_matches)
    intersection <- which(region_matches %in% stn_matches)
    if(length(intersection)) {      
      both_matches <- region_matches[intersection]
      stn2 <-  USAirportWeatherStations[both_matches, c("Station", "State", "airportCode")]  
    }
    if(length(intl_section)) {      
      both_matches <- iName_matches[intl_section]
      intl_stn2 <-  IntlWxStations[both_matches,]
    }
    if(!length(intersection) & !length(intl_section)) {      
      message("Could not match both StationName and Region")
      message("Will try matching just the Station Names")
    }
  }

  if(!is.null(stn2) & !is.null(intl_stn2)) {
    return(list(stn2, intl_stn2))
  }    
  
  if(!is.null(stn2)){
    return(stn2)
  }    
  if(!is.null(intl_stn2)){
    return(intl_stn2)
  }    
  
  #No region hits, just the StationName matches
  if(length(iName_matches)){
  #  print(paste(stationName, intl_matches))
    i_stns <- (IntlWxStations[iName_matches, ])
  }    
  if(length(stn_matches)){
    us_stns <- USAirportWeatherStations[stn_matches, 
                                        c("Station", 
                                          "State", 
                                          "airportCode")]  
  }

  if(!is.null(us_stns) & !is.null(i_stns)) {
    return(list(us_stns, i_stns))
  }    
  
  if(!is.null(us_stns)){
    return(us_stns)
  }    
  if(!is.null(i_stns)){
    return(i_stns)
  }    
  
}


