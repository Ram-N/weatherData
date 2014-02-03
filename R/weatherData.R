require(plyr)

#' @title Gets weather data for a single date
#' 
#' @description Given a valid station and a single date this function
#'  will return a dataframe of time-stamped weather data
#' 
#' 
#' @param station is a valid 3-letter airport code or a valid Weather Station ID
#' @param date is a valid string representing a date in the past (YYYY-MM-DD)
#' @param station_type can be \code{airportCode} which is the default, or it
#'  can be \code{id} which is a weather-station ID

#' @param opt_temperature_only Boolen flag to indicate only Temperature data is to be returned (default TRUE)
#' @param opt_compress_output Boolean flag to indicate if a compressed output is preferred. 
#'  If this option is set to be TRUE, only every other record is returned
#' @param opt_verbose Boolean flag to indicate if verbose output is desired
#' @param opt_warnings Boolean flag to turn off warnings. Default value is TRUE, to keep
#' the warnings on.
#' 
#' @return A data frame with each row containing: \itemize{
#' \item Date and Time stamp for the date specified
#' \item Temperature and/or other weather columns 
#' }
#' @return A data frame containing the Date & Time stamp and Weather data columns
#' @import plyr
#' @export
getWeatherData <- function(station, 
                           date, 
                                station_type="airportCode",
                                opt_temperature_only = T,
                                opt_compress_output = FALSE,
                                opt_verbose = FALSE,
                                opt_warnings=TRUE) {

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
    letterCode <- ifelse(nchar(station) == 3, "K", "")
    
    final_url <- paste0(airp_url, letterCode, station,
                     '/',y,
                     '/',m,
                     '/',d,
                     coda)
  }    
  
  if(opt_verbose) {
    message(sprintf("Getting data from:\n %s\n",final_url))
    #message(sprintf("%s %s \n",letterCode, station))    
  }
  
  #------------------
  # Now read the data from the URL
  #-------------------
  
  # reading in as raw lines from the web server
  # contains <br> tags on every other line
#  u <- url(final_url)
  wxdata <- readUrl(final_url)
  #print(str(wxdata))


if(grepl(pattern="No daily or hourly history data", wxdata[3]) ==TRUE){
  if(opt_warnings) {
    warning(sprintf("Unable to get data from URL
                  \n Check Station name %s 
                  \n Check If Date is in the future %s
                  \n Inspect the validity of the URL being tried:\n %s \n", station, date, final_url))
    message("For non-US Airports, try the 4-letter Code")  
  }
  return(NULL)      
}


if(is.na(wxdata[1])) {
  warning(sprintf("Unable to get data from URL\n Check if URL is reachable"))
  return(NULL) #have to try again
}
# print(is.na(wxdata))
  # wxdata <- readLines(u) #wxdata is not a chr vector, each line = 1 element of the vector
  # close(u)

  # only keep records with more than 3 rows of data
  if(length(wxdata) < 3 ) {
    warning(paste("not enough records found for", station, 
                "/n Only", length(wxdata), "records."))
    return(NULL)
  }
  # remove the first line
  wxdata <- wxdata[-c(1)]    

  #remove the last line
  #wxdata <- wxdata[-c(length(wxdata))]    
  
  if(opt_compress_output==TRUE) {
    # remove odd rows starting from 3, in order to reduce volume
    wxdata <- wxdata[-seq(3, length(wxdata), by=2)]    
  }

  wxdata <- gsub("<br />", "", wxdata) #get rid of the trailing br at the end of each line
  
  # extract header and cleanup
  header_row <- wxdata[1]
#   if(opt_verbose ==TRUE)
#     print(the_header)
  
  # convert to csv, skipping header
  tC <- textConnection(paste(wxdata, collapse='\n'))
  wxdata <- read.csv(tC, as.is=TRUE, row.names=NULL, header=FALSE, skip=1) #makes it a data frame
  close(tC)
  
  header_row <- make.names(strsplit(header_row, ',')[[1]]) #make the col.names syntactically valid
  #     print(the_header)
  #     print(length(the_header))
  # assign column names
  names(wxdata) <- header_row
  
  # convert Time column into properly encoded date time
  wxdata$DateTime <- as.POSIXct(strptime(paste(date,wxdata[[1]]), format='%Y-%m-%d %I:%M %p'))
  
  # remove UTC and software type columns
  wxdata$DateUTC.br. <- NULL
  wxdata$SoftwareType <- NULL
  
  # sort and fix rownames
  wxdata <- wxdata[order(wxdata$Time), ] #sort the rows by increasing time
  row.names(wxdata) <- 1:nrow(wxdata) #give the dataframe rownames
  
  df <- wxdata
  # print(paste("Column names", names(df)))
  if(opt_temperature_only) {    
    #subset to the columns of interest
    temp_column <- grep("Temperature", names(df))[1]
    time_column <- grep("DateTime", names(df))[1]
    names(wxdata)[time_column] <- "Time" #rename it back
    
    if(!is.na(temp_column) & !(is.na(time_column))) {
      df <- wxdata[, c(time_column, temp_column)]  
    } else {
      df <- NULL
    }
        
  }
  
  return(df)
}