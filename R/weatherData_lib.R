require(plyr)

IsDateInvalid <- function (date) {
  # d <- try( as.Date( date, format= "%d-%m-%Y %H:%M:%S" ) ) #original
  d <- try( as.Date( date) )
  if( class( d ) == "try-error" || is.na( d ) )  {
    print(paste( "Invalid date supplied", date ))
    return(1)
  }
  return(0) #is okay
}

#' @title Check if the station type is airportCode or id
#' @description We are checking if a valid station type was given to the function.
#' @param station_type can be \code{airportCode} which is the default, or it
#'  can be \code{id} which is a weather-station ID
#'  @seealso getStationCode
IsStationTypeInvalid <- function (station_type) {
    if(station_type != "airportcode" && 
         station_type != "id")  {
      print(paste( "Invalid station_type supplied", station_type ))
      return(1)
    }
    return(0) #is okay
  }
  

readUrl <- function(final_url) {
  out <- tryCatch(
{
  #if you want to use more than one R expression in the "try" part use {}
  # 'tryCatch()' will return the last evaluated expression 
  # in case the "try" part was completed successfully  
  #message("This is the 'try' part")  
  u <- url(final_url)  
  # readLines(u, warn=FALSE) 
  readLines(u) 
  # The return value of `readLines()` is the actual value 
  # that will be returned in case there is no condition 
  # (e.g. warning or error). 
  # You don't need to state the return value via `return()` as code 
  # in the "try" part is not wrapped insided a function (unlike that
  # for the condition handlers for warnings and error below)
},
error=function(cond) {
  message(paste("URL does not seem to exist:", final_url))
  message("The original error message:")
  message(cond)
  return(NA)  # Choose a return value in case of error
},
warning=function(cond) {
  message(paste("URL caused a warning:", final_url))
  message("Here's the original warning message:")
  message(cond)
  # Choose a return value in case of warning
  return(NA)
},
 finally=  close(u)
#   # NOTE:
#   # Here goes everything that should be executed at the end,
#   # regardless of success or error.
#   # If you want more than one expression to be executed, then you 
#   # need to wrap them in curly brackets ({...}); otherwise you could
#   # just have written 'finally=<expression>' 
#   message(paste("Processed URL:", url))
#   message("Some other message at the end")
# }
  )    
return(out)
}
#----------------------------------------------------------------

#' This function gets weather data, given a valid station and a single date
#' 
#' TODO: Error checking for valid station name, date, station.type
#' 
#' @param station is a valid 3-letter airport code or a valid Weather Station ID
#' @param date is a valid string representing a date in the past (YYYY-MM-DD)
 #' @param station_type can be \code{airportCode} which is the default, or it
#'  can be \code{id} which is a weather-station ID

#' @param opt_temperature_only is a flag to indicate only Temperature data is to be returned (default TRUE)
#' @param opt.compress.output flag to indicate if a compressed output is preferred. If TRUE, only every other record is returned.
#' @param opt_verbose A Flag to indicate if verbose output is desired
#' 

#' @export
getSingleDayWeather <- function(station, 
                                date, 
                                station_type="airportCode",
                                opt_temperature_only = T,
                                opt.compress.output = FALSE,
                                opt_verbose = FALSE) {
  
  # parse date  
  if(IsDateInvalid(date)) {
    warning(sprintf("Unable to build a valid URL \n Date format Invalid %s \n Input date should be within quotes \n and of the form 'YYYY-MM-DD' \n\n", date))     
    return(NULL)
  }

  station_type <- tolower(station_type)
  if(IsStationTypeInvalid(station_type)) {
    warning("Station Type is Invalid")
    return(NULL)
  }
  
  
  date <- as.Date(date)
  m <- as.integer(format(date, '%m'))
  d <- as.integer(format(date, '%d'))
  y <- format(date, '%Y')
  
  # compose final url
  # Type can be ID OR Airport  
  if(station_type=="id") {
    base_url <- 'http://www.wunderground.com/weatherstation/WXDailyHistory.asp?'
    final_url <- paste0(base_url,
                       'ID=', station,
                       '&month=', m,
                       '&day=', d, 
                       '&year=', y,
                       '&format=1')    
  }
  
  #for airport codes
  if(station_type=="airportcode") {
    airp_url = 'http://www.wunderground.com/history/airport/'
    coda = '/DailyHistory.html?format=1'    
    
    #If an airportLetterCode is not supplied, try with K
    #If it is, just use that code
    letterCode <- ifelse(length(station_type == 3), "K", "")
    
    
    final_url <- paste0(airp_url, letterCode, station,
                     '/',y,
                     '/',m,
                     '/',d,
                     coda)
  }    
  if(opt_verbose) 
    cat(sprintf("Getting data from:\n %s\n",final_url))
  
  #------------------
  # Now read the data from the URL
  #-------------------
  
  # reading in as raw lines from the web server
  # contains <br> tags on every other line
#  u <- url(final_url)
  raw_data <- readUrl(final_url)
  #print(str(raw_data))

if(grepl(pattern="No daily or hourly history data", raw_data[3]) ==TRUE){
  warning(sprintf("Unable to get data from URL \n Check Station name %s \n Inspect the validity of the URL being tried:\n %s \n", station, final_url))
      return(NULL) #have to try again      
}


if(is.na(raw_data[1])) {
  warning(sprintf("Unable to get data from URL\n Check if URL is reachable"))
  return(NULL) #have to try again
}
# print(is.na(raw_data))
  # raw_data <- readLines(u) #raw_data is not a chr vector, each line = 1 element of the vector
  # close(u)

  # only keep records with more than 3 rows of data
  if(length(raw_data) < 3 ) {
    warning(paste("not enough records found for", station, 
                "/n Only", length(raw_data), "records."))
    return(NULL)
  }
  # remove the first line
  raw_data <- raw_data[-c(1)]    

  #remove the last line
  #raw_data <- raw_data[-c(length(raw_data))]    
  
  if(opt.compress.output==TRUE) {
    # remove odd numbers starting from 3 --> end
    raw_data <- raw_data[-seq(3, length(raw_data), by=2)]    
  }

  raw_data <- gsub("<br />", "", raw_data) #get rid of the trailing br at the end of each line
  
  # extract header and cleanup
  header_row <- raw_data[1]
#   if(opt_verbose ==TRUE)
#     print(the_header)
  
  # convert to CSV, without header
  tC <- textConnection(paste(raw_data, collapse='\n'))
  raw_data <- read.csv(tC, as.is=TRUE, row.names=NULL, header=FALSE, skip=1) #makes it a data.frame
  close(tC)
  
  header_row <- make.names(strsplit(header_row, ',')[[1]]) #make the col.names syntactically valid
  #     print(the_header)
  #     print(length(the_header))
  # assign column names
  names(raw_data) <- header_row
  
  # convert Time column into properly encoded date time
  raw_data$Time <- as.POSIXct(strptime(paste(date,raw_data[[1]]), format='%Y-%m-%d %I:%M %p'))
  
  # remove UTC and software type columns
  raw_data$DateUTC.br. <- NULL
  raw_data$SoftwareType <- NULL
  
  # sort and fix rownames
  raw_data <- raw_data[order(raw_data$Time), ] #sort the rows by increasing time
  row.names(raw_data) <- 1:nrow(raw_data) #give the dataframe rownames
  
  df <- raw_data
  if(opt_temperature_only) {
    df <- raw_data[c("Time", "TemperatureF")]
  }
  
  return(df)
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
#' @export 
IsStationDataAvailable<- function (station, station_type, start_date, end_date) {
  lst_start <- getSingleDayWeather(station, start_date, station_type, 
                                   opt_temperature_only=T, opt.compress.output=T, 
                                   opt_verbose=T)
  lst_end <- getSingleDayWeather(station, end_date, station_type,  opt_temperature_only=T, 
                                        opt.compress.output=T, opt_verbose=T)
  st_row = nrow(lst_start) #takes on a value of NULL if station has no data
  en_row = nrow(lst_end)
  
  cat(sprintf("For %s \n Found %d records for %s\n Found %d records for %s \n",
                station, st_row, start_date, en_row, end_date))
  
  if (is.integer(st_row) && is.integer(en_row))
  {
    return(1)
  }
  else {
    return(0) #nothing found
  }
}


#'  Getting data for full date-range
#'  
#' @details For each day in the date range, this function fetches Weather Data
#' Internally, it makes multiple calls to getSingleDayWeather
#' 
#' @param station is a valid 3-letter airport code or a valid Weather Station ID
#' @param start_date is a valid string representing a date in the past (YYYY-MM-DD, all numeric)
#' @param end_date is a a valid string representing a date in the past (YYYY-MM-DD, all numeric) and is greater than start_date  
#' @param station.type = "airportCode" (3-letter airport code) or "ID" (Wx call Sign)
#' @export
getWeatherForDateRange <- function(station, station.type, start_date, end_date) {
  
  validity = IsStationDataAvailable(station, station.type, start_date, end_date)
  if (validity==0){
    print(paste("Station data not available.", station, start_date, "to", "end_date"))
    return(0) #returning a NULL to signal no data
  }
  
  date.range <- seq.Date(from=as.Date(start_date), to=as.Date(end_date), by='1 day')
  print(station)
  # pre-allocate list
  l <- vector(mode='list', length=length(date.range))
  
  # loop over dates, and fetch data
  for(i in seq_along(date.range))
  {
    l[[i]] <- getSingleDayWeather(station,  date.range[i], station.type)
    message(paste(station, i, date.range[i], ":",  nrow(l[[i]]) ))
  }
  
  #print(l)  
  # stack elements of list into DF, filling missing columns with NA
  d <- ldply(l)
    
  outFileName <- paste0(station,"_",start_date,"_",end_date)
  outFileName <- paste(outFileName, "csv","gz", sep=".")
  
  # save to CSV
  write.csv(d, file=gzfile(outFileName), row.names=FALSE)
  print(paste("wrote:", outFileName, "to", getwd()))
}
