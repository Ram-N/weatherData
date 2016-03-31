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
#'@examples
#'\dontrun{
#' data_okay <- checkDataAvailability("HECA", "2014-01-01")
#' 
#'}
#' @export 
checkDataAvailability <- function (station_id, 
                                   check_date, 
                                   station_type="airportCode") {  
  df <- getDetailedWeather(station_id, 
                          check_date, 
                          station_type, 
                          opt_temperature_columns=T, 
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
#' @examples
#' \dontrun{
#' data_okay <- checkDataAvailabilityForDateRange("BOS", 
#'                                                "2011-01-01", 
#'                                                "2011-03-31")
#'}
#' @export 
checkDataAvailabilityForDateRange<- function (station_id, 
                                     start_date, 
                                     end_date,
                                     station_type="airportCode") { 
  
  if (!isDateRangeValid(start_date, end_date)) return(NULL)
  
  
  df_start <- getDetailedWeather(station_id, 
                                 start_date, 
                                 station_type, 
                                 opt_temperature_columns=T, 
                                 opt_compress_output=T, 
                                 opt_verbose=T)
  
  df_end <- getDetailedWeather(station_id, 
                               end_date, 
                               station_type,  
                               opt_temperature_columns=T, 
                               opt_compress_output=T, 
                               opt_verbose=T)
  
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
    message("Data is Available for the interval.\n")
    return(1)
  }
  else {
    message("Data is Not Available\n")
    return(0) #nothing found
  }
}


#' @title Quick Check to see if WeatherUnderground has Summarized Weather Data for given station
#'  for a custom range of dates
#' @description Before we attempt to fetch the data for a big time interval of dates, this 
#'  function is useful to see if the data even exists.
#'  @details This functions build a custom URL and checks for the data. If available, 
#'   it will find one row for each date in the date range.
#' @param station_id is a valid 3-letter airport code or a valid Weather Station ID
#' @param station_type is either \code{airportCode} or \code{id}
#' @param start_date is a valid string representing a date in the past (YYYY-MM-DD, all numeric)
#' @param end_date is a a valid string representing a date in the past (YYYY-MM-DD, all numeric) and is greater than start_date.
#'  Default is NULL, in which case the end_date is taken to the same as the start_date
#' 
#' @return 1 if the Station did have weather records, 0 if nothing was found  
#' @examples
#' \dontrun{
#' data_okay <- checkSummarizedDataAvailability("GIG", 
#'                                              "2000-01-01",
#'                                              "2005-12-31")
#'}
#' @export 
checkSummarizedDataAvailability<- function (station_id, 
                                            start_date, 
                                            end_date=NULL,
                                            station_type="airportCode") {  
  df <- getSummarizedWeather(station_id, 
                             start_date,
                             end_date,
                             station_type,
                             opt_temperature_columns=TRUE,
                             opt_verbose=TRUE)
  
  
  st_row = nrow(df) #takes on a value of NULL if station has no data
  
  message(sprintf("Checking Summarized Data Availability For %s", station_id))
  if (is.null(df)) {  
    message(sprintf("Found 0 records for %s to %s", start_date, end_date))
  } else {
    if (!is.null(end_date)) {  
      message(sprintf("Found %d records for %s to %s", st_row, start_date, end_date))
    } else{
      message(sprintf("Found %d records for %s", st_row, start_date))
      
    }
  }
  
  
  if (is.integer(st_row)){
    message("Data is Available for the interval.")
    return(1)
  } else {
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
#'  Internally, it makes multiple calls to \code{getDetailedWeather}.
#' 
#' @param station_id is a valid 3- or 4-letter Airport code or a valid Weather Station ID
#'  (example: "BUF", "ORD", "VABB" for Mumbai).
#'  Valid Weather Station "id" values: "KFLMIAMI75" or "IMOSCOWO2" You can look these up
#'   at wunderground.com
#' @param start_date string representing a date in the past ("YYYY-MM-DD", all numeric)
#' @param end_date If an interval is to be specified, end_date 
#'  is a string representing a date in the past ("YYYY-MM-DD", all numeric) 
#'  and greater than the \code{start_date}  (Optional)
#' @param station_type = "airportCode" (3- or 4-letter airport code) or "ID" (Wx call Sign)
#' @param opt_detailed Boolen flag to indicate if detailed records for the station are desired.
#' (default FALSE). By default only one records per date is returned.
#' @param opt_verbose Boolean flag to indicate if verbose output is desired
#' @param daily_min A boolean indicating if only the Minimum Temperatures are desired
#' @param daily_max A boolean indicating if only the Maximum Temperatures are desired
#' @param opt_write_to_file If TRUE, the resulting dataframe will be stored in a CSV file. 
#'  Default is FALSE
#' @param opt_temperature_columns Boolen flag to indicate only Temperature data is to be returned (default TRUE)
#' @param opt_all_columns Boolen flag to indicate whether all available data is to be returned (default FALSE)
#' @param opt_custom_columns Boolen flag to indicate if only a user-specified set of columns are to be returned. (default FALSE)
#'  If TRUE, then the desired columns must be specified via \code{custom_columns}
#' @param custom_columns Vector of integers specified by the user to indicate which columns to fetch. 
#'  The Date column is always returned as the first column. The 
#'  column numbers specfied in \code{custom_columns} are appended as columns of 
#'   the data frame being returned (default NULL). The exact column numbers can be
#'   found by visiting the weatherUnderground URL, and counting from 1. Note that if \code{opt_custom_columns} is TRUE, 
#'   then \code{custom_columns} must be specified.
#' @import plyr
#' @import curl
#' @references For a list of valid Weather Stations, try this format
#'  \url{http://www.wunderground.com/weatherstation/ListStations.asp?selectedCountry=United+States}
#'  and replace with your country of interest
#' @return A data frame with each row containing: \itemize{
#' \item Date and Time stamp (for each date specified)
#' \item Temperature and/or other weather columns sought
#' }
#'@examples
#'\dontrun{
#'dat <- getWeatherForDate("PHNL", "2013-08-10", 2013-08-31")
#'d3<- getWeatherForDate("CWWF", start_date="2014-03-01", 
#'                       end_date = "2014-03-03", 
#'                       opt_detailed = TRUE, 
#'                       opt_all_columns = TRUE)
#'}
#' @export
getWeatherForDate <- function(station_id, 
                              start_date, 
                              end_date =NULL,
                              station_type="airportCode",
                              opt_detailed = FALSE,                
                              opt_write_to_file = FALSE,
                              opt_temperature_columns=TRUE,
                              opt_all_columns=FALSE,
                              opt_custom_columns=FALSE,
                              custom_columns=NULL,
                              opt_verbose=FALSE,
                              daily_min=FALSE,
                              daily_max=FALSE) {

  coda <- NULL

  
  if(opt_detailed==TRUE){
    
    if(is.null(end_date)) {#single Date has been supllied
      validity <- checkDataAvailability(station_id, start_date, station_type)
      end_date <- start_date #the same day
    } else { #input is a date Range
      if (!isDateRangeValid(start_date, end_date)) return(NULL)
      coda <- paste0("_", end_date) #used for naming files
      validity <- checkDataAvailabilityForDateRange(station_id,  start_date, end_date, station_type)
    }
    
    if (validity==0){
      warning(paste("\nStation data not available.", station_id, start_date, "to", end_date))
      return(NULL) 
    }
    
    
    date.range <- seq.Date(from=as.Date(start_date), to=as.Date(end_date), by='1 day')
    
    #Just print out once to let user know which columns are being fetched
    message("Will be fetching these Columns:")
    print(names(getDetailedWeather(station_id,  
                                        date.range[1], 
                                        station_type,
                                        opt_temperature_columns,
                                        opt_all_columns,
                                        opt_custom_columns,
                                        custom_columns,
                                        opt_compress_output=FALSE,
                                        opt_verbose,
                                        opt_warnings=TRUE) ))
    
    
    message("Begin getting Daily Data for ", station_id)
    # pre-allocate list
    l <- vector(mode='list', length=length(date.range))
    
    # loop over dates, and fetch data
    for(i in seq_along(date.range))
    {
      single_day_df <- getDetailedWeather(station_id,  
                                          date.range[i], 
                                          station_type,
                                          opt_temperature_columns,
                                          opt_all_columns,
                                          opt_custom_columns,
                                          custom_columns,
                                          opt_compress_output=FALSE,
                                          opt_verbose,
                                          opt_warnings=TRUE)

      message(paste(station_id, i, date.range[i], ": Fetching",
                    nrow(single_day_df), "Rows" , "with",
                    ncol(single_day_df), "Column(s)" )
              )      
      if(daily_min | daily_max) {
        l[[i]] <- keepOnlyMinMax(single_day_df, daily_min, daily_max)
      } else{ #store the full day's dataframe
        l[[i]] <- single_day_df        
      }
    }
    
    # stack elements of list into DF, filling missing columns with NA
    df <- ldply(l)
    
    
  } else { #opt_detailed is FALSE. Summary data desired
    
    if(!checkSummarizedDataAvailability(station_id,
                                    start_date,
                                    end_date,
                                    station_type)) return(NULL)
   # inputs are good 
    df <- getSummarizedWeather(station_id,
                               start_date,
                               end_date,
                               station_type,
                               opt_temperature_columns,
                               opt_all_columns,
                               opt_custom_columns,
                               custom_columns,
                               opt_verbose=FALSE)    
   #Print out once to let user know which columns are being fetched
   message("Will be fetching these Columns:")
   print(names(df))  
  }
  
  #persist the data frame, if user requires it
  if(opt_write_to_file) {
    #Take care of filename and Row Names for min/max
    prepend <- NULL
    if(daily_max & daily_min) {#both
      names(df) <- c("TimeMin", "MinTemp","TimeMax", "MaxTemp")
      prepend <- "MinMax_"
    } else if(daily_min){
      names(df) <- c("TimeMin", "MinTemp")
      prepend <- "Min_"
    } else if(daily_max){
      names(df) <- c("TimeMax", "MaxTemp")
      prepend <- "Max_"
    }
    
    outFileName <- paste0(prepend, station_id,"_",start_date, coda)  
    outFileName <- paste(outFileName, "csv","gz", sep=".")
    
    write.csv(df, file=gzfile(outFileName), row.names=FALSE)
    message(paste("wrote:", outFileName, "to", getwd()))    
  }  
  
  
  return(df)
}

#checkSummarizedDataAvailability("KBUF", "2012-12-12", end_date=NULL)

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
#'  Internally, it makes multiple calls to \code{getDetailedWeather}.
#'  
#' @param station_id is a valid Weather Station ID
#'  (example: "BUF", "ORD", "VABB" for Mumbai).
#'  Valid Weather Station "id" values: "KFLMIAMI75" or "IMOSCOWO2" You can look these up
#'   at wunderground.com. You can get station_id's for a given location
#'   by calling \code{getStationCode()}
#' @param year is a valid year in the past (numeric, YYYY format)
#' @param station_type = "airportCode" (3 or 4 letter airport code) or "ID" (Wx call Sign)
#' @param opt_detailed Boolen flag to indicate if detailed records for the station are desired.
#' (default FALSE). By default only one records per date is returned.
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
#' 
#' # If opt_detailed is turned on, you will get a large data frame
#' wx_Singapore <- getWeatherForYear("SIN", 2014, opt_detailed=TRUE)
#'}
#' @export
getWeatherForYear <- function(station_id,
                              year,
                              station_type="airportCode",
                              opt_detailed=FALSE,
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
  
  getWeatherForDate(station_id, 
                    first_day, 
                    last_day, 
                    station_type, 
                    opt_detailed) 
}



#' Get the latest recorded temperature for a location
#' 
#' @description Function will return the latest avialable
#' temperature at a specified location.
#' 
#' @details A wrapper for \code{getDetailedWeather()}, it returns the last
#'  record in the web page. Uses \code{Sys.Date()} to get current time. This function
#'  returns temperature in Farenheit or Celcius depending on the caller's location.
#'
#' @param station_id is a valid Weather Station ID
#'  (example: "BUF", "ORD", "VABB" for Mumbai).
#'  Valid Weather Station "id" values: \code{"KFLMIAMI75"} or \code{"IMOSCOWO2"} You can look these up
#'   at wunderground.com. You can get station_id's for a given location
#'   by calling \code{getStationCode()}
#' @return A one row data frame containing: \itemize{
#' \item Date and Time stamp (for when the latest temperature reading was recorded)
#' \item Temperature for the station in Farenheit (or Celcius)
#' }
#' @references For a list of valid Weather Stations, try this format
#'  \url{http://www.wunderground.com/weatherstation/ListStations.asp?selectedCountry=United+States}
#'  and replace with your country of interest
#' 
#' @examples 
#' \dontrun{
#' getCurrentTemperature(station ="HNL")
#' }
#' @export
getCurrentTemperature <- function(station_id){  
  #Try with tomorrow's date first, in case location is ahead in timezone
  #We expect this to fail if the date is in the future. That's why
  # the warnings are FALSE.
  
  temp.df <- getDetailedWeather(station_id,
                            Sys.Date()+1,  
                            opt_warnings=FALSE)
  
  #If the second call also fails, we want to be warned, so opt_warnings=T
  #The only reason this can fail is if the station is invalid
  if(is.null(temp.df))  temp.df <- getDetailedWeather(station_id, 
                                                      Sys.Date(),
                                                      opt_warnings=TRUE)  
  temp.df[nrow(temp.df), ]
}


getDailyMinMaxTemp <- function(station_id, start_date, 
                               end_date =NULL,
                               daily_min=TRUE,
                               daily_max=TRUE,                              
                               station_type = 'airportCode',
                               opt_write_to_file = FALSE){  
  
  #Not exposing this function at this time.
  
  
#' Get the daily minimum (maximum) temperatures for a given weather stations
#' 
#' Given a StationID and a set of dates, this function returns the 
#' Daily Minimum and/or Maximum temperatures recorded, along with timestamps
#' 
#' @details This functions fetches all the records for 
#' each date specified, but it only retaints the min and/or max record, along 
#'  with the timestamp.
#'  
#' @param station_id is a valid 3- or 4-letter Airport code or a valid Weather Station ID
#'  (example: "BUF", "ORD", "VABB" for Mumbai).
#'  Valid Weather Station "id" values: "KFLMIAMI75" or "IMOSCOWO2" You can look these up
#'   at wunderground.com
#' @param start_date is a valid string representing a date in the past (YYYY-MM-DD, all numeric)
#' @param end_date (optional) If an interval is to be specified, end_date 
#'  is a a valid string representing a date in the past (YYYY-MM-DD, all numeric) 
#'  and greater than start_date  
#' @param daily_min A boolean indicating if the Minimum Temperatures are desired
#' @param daily_max A boolean indicating if the Maximum Temperatures are desired
#'  Both \code{daily_min} and \code{daily_max} can be TRUE, but at least one of 
#'  them should be TRUE.
#' @param station_type = "airportCode" or "ID" (Wx call Sign)
#' @param opt_write_to_file If TRUE, the resulting dataframe will be stored in a CSV file. 
#'  Default is FALSE
#'  
#' @return A data frame with each row containing: \itemize{
#' \item Date and Time stamp (for when that day's minimum temperature was recorded)
#' \item Minimum Temperature for the station in Farenheit (or Celcius)
#' \item Date and Time stamp (for when that day's maximum temperature was recorded)
#' \item Maximum Temperature for the station in Farenheit (or Celcius)
#' }
#' @examples
#'\dontrun{
#'dat <- getDailyMinMaxTemp("KIAH", "2013-08-10", 2013-08-31", daily_max=TRUE)
#'dat <- getDailyMinMaxTemp("KBIL", "2013-08-10", daily_max=T)
#'dat <- getDailyMinMaxTemp("EGLL", "2013-08-10", daily_max=T, daily_min=TRUE)
#'}
#' at export 
  
  if((!daily_min) & (!daily_max)){
    warning("When calling getDailyMinMaxTemp, \n at least one of daily_min or daily_max should be TRUE")
    return(NULL)
  }
  
  temp.df <- getWeatherForDate(station_id, 
                               start_date,
                               end_date, 
                               station_type,
                               daily_min,
                               daily_max,
                               opt_write_to_file)
  
  if(daily_min & daily_max){
    temp.df$TimeMin <- as.POSIXct(temp.df[,1], origin="1970-01-01")
    temp.df$TimeMax <- as.POSIXct(temp.df[,3], origin="1970-01-01")  
  }
  else if(daily_min){
    temp.df$TimeMin <- as.POSIXct(temp.df[,1], origin="1970-01-01")
  }
  else if(daily_max){
    temp.df$TimeMax <- as.POSIXct(temp.df[,1], origin="1970-01-01")
  }
  
  return(temp.df)  
}


getTemperatureForDate <- function(station_id, 
                              start_date, 
                              end_date =NULL,
                              station_type="airportCode",
                              daily_min=FALSE,
                              daily_max=FALSE,                              
                              opt_write_to_file = FALSE
) {  

# Not exporting this function for now. Functionality exists elsewhere.  
#'  Getting Temperature data for a single date (or a range of dates)
  #'   
  #' @description This function will return a (fairly large) data frame. If you are going 
     #'  to be using this data for future analysis, you can store the results in a CSV file
     #'   by setting \code{opt_write_to_file} to be TRUE
     #' @details For each day in the date range, this function fetches Temperature Data. It will fetch
     #' all the available values, which is typically multiple rows for each day, with a time stamp.
     #'  This function is a light wrapper for  \code{getWeatherForDate}.
     #' 
     #' @param station_id is a valid station code or a valid Weather Station ID
     #'  (example: "BUF", "ORD", "VABB" for Mumbai).
     #'  Valid Weather Station "id" values: "KFLMIAMI75" or "IMOSCOWO2" You can look up
     #'   weather station IDs at wunderground.com
     #' @param start_date is a valid string representing a date in the past (YYYY-MM-DD, all numeric)
     #' @param end_date (optional) If an interval is to be specified, end_date 
     #'  is a a valid string representing a date in the past (YYYY-MM-DD, all numeric) 
     #'  and greater than start_date  
     #' @param station_type = "airportCode" (4-letter airport code) or "ID" (Wx call Sign)
     #' @param daily_min A boolean indicating if only the Minimum Temperatures are desired
     #' @param daily_max A boolean indicating if only the Maximum Temperatures are desired
     #' @param opt_write_to_file If TRUE, the resulting dataframe will be stored in a CSV file. 
     #'  Default is FALSE
     #' @seealso getWeatherForDate, getDetailedWeather
     #' @references For a list of valid Weather Stations, try this format
     #'  \url{http://www.wunderground.com/weatherstation/ListStations.asp?selectedCountry=United+States}
     #'  and replace with your country of interest
     #' @return A data frame with each row containing: \itemize{
     #' \item Date and Time stamp (for each date specified)
     #' \item Temperature values
     #' }
     #'@examples
     #'\dontrun{
     #' dat <- getTemperatureForDate("KPHX", "2013-08-10", 2013-08-13")
     #'}
     #' at export
  
  getWeatherForDate(station_id,start_date,end_date,station_type,
                    opt_temperature_columns=T, #this flag is preset.
                    daily_min,
                    daily_max,
                    opt_write_to_file)
  
}
