require(plyr)

IsDateInvalid <- function (date) {
  # d <- try( as.Date( date, format= "%d-%m-%Y %H:%M:%S" ) ) #original
  d <- try( as.Date( date) )
  if( class( d ) == "try-error" || is.na( d ) )  {
    print(paste( "Invalid date supplied", date ))
    return(1)
  }
  #TODO:
  #If a date in the future is supplied, print an error message
  
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
      warning(paste( "Invalid station_type supplied", station_type ))
      return(1)
    }
    return(0) #is okay
  }
  

readUrl <- function(final_url) {
  out <- tryCatch({
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




#' This function gets weather data, given a valid station and a single date
#' 
#' TODO: Error checking for valid station name, date, station_type
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
    message(sprintf("Getting data from:\n %s\n",final_url))
  
  #------------------
  # Now read the data from the URL
  #-------------------
  
  # reading in as raw lines from the web server
  # contains <br> tags on every other line
#  u <- url(final_url)
  raw_data <- readUrl(final_url)
  #print(str(raw_data))

if(grepl(pattern="No daily or hourly history data", raw_data[3]) ==TRUE){
  warning(sprintf("Unable to get data from URL
                  \n Check Station name %s 
                  \n Check If Date is in the future %s
                  \n Inspect the validity of the URL being tried:\n %s \n", station, date, final_url))
  message("For International Airports, try the 4-letter Code")
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
    # remove odd rows starting from 3, to reduce volume
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
  # print(paste("Column names", names(df)))
  if(opt_temperature_only) {    
    #subset to the columns of interest
    temp_column <- grep("Temperature", names(df))[1]
    time_column <- grep("Time", names(df))[1]
    if(!is.na(temp_column) & !(is.na(time_column))) {
      df <- raw_data[, c(time_column, temp_column)]  
    } else {
      df <- NULL
    }
        
  }
  
  return(df)
}