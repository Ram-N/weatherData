
# To make it robust
# http://stackoverflow.com/questions/12193779/how-to-write-trycatch-in-r/12195574#12195574


require(plyr)

#' @export
#' 
#' 
IsDateInvalid <- function (date) {
  # d <- try( as.Date( date, format= "%d-%m-%Y %H:%M:%S" ) ) #original
  d <- try( as.Date( date) )
  if( class( d ) == "try-error" || is.na( d ) )  {
    print(paste( "Invalid date supplied", date ))
    return(1)
  }
  return(0) #is okay
}


IsStateTypeInvalid <- function (station_type) {
    if(station_type != "airportcode" && 
         station_type != "id")  {
      print(paste( "Invalid station_type supplied", station_type ))
      return(1)
    }
    return(0) #is okay
  }
  

#' This function gets data from Wx Underground, given a valid station and date
#' TODO: Error checking for valid station name, date, station.type
FetchDailyWeatherForStation <- function(station, 
                                        date, 
                                        station_type="airportCode",
                                        opt.temp.only = T,
                                        opt.compress.output = FALSE,
                                        opt.debug = FALSE
                                        ) {
  
  # parse date  
  if(IsDateInvalid(date)) {
    print("Date is Invalid")
    return(NULL)
  }

  station_type <- tolower(station_type)
  if(IsStateTypeInvalid(station_type)) {
    print("Station Type is Invalid")
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
    final_url <- paste(base_url,
                       'ID=', station,
                       '&month=', m,
                       '&day=', d, 
                       '&year=', y,
                       '&format=1', sep='')    
  }
  
  #for airport codes
  if(station_type=="airportcode") {
    airp_url = 'http://www.wunderground.com/history/airport/K'
    coda = '/DailyHistory.html?format=1'
    
    final_url <- paste(airp_url, station,
                     '/',y,
                     '/',m,
                     '/',d,
                     coda, sep='')
  }  
  
  # reading in as raw lines from the web server
  # contains <br> tags on every other line
  if(opt.debug) print(final_url)
  
  u <- url(final_url)
  the_data <- readLines(u) #the_data is not a chr vector, each line = 1 element of the vector
  close(u)
    
  # only keep records with more than 5 rows of data
  if(length(the_data) < 5 ) {
    print(paste("not enough records found for", station))
    return(NULL)
  }
  # remove the first line
  the_data <- the_data[-c(1)]    

  #remove the last line
  #the_data <- the_data[-c(length(the_data))]    
  
  if(opt.compress.output==TRUE) {
    # remove odd numbers starting from 3 --> end
    the_data <- the_data[-seq(3, length(the_data), by=2)]    
  }

  the_data <- gsub("<br />", "", the_data) #get rid of the trailing br at the end of each line
  
  
  # extract header and cleanup
  the_header <- the_data[1]
  the_header <- make.names(strsplit(the_header, ',')[[1]]) #make the col.names syntactically valid
  #     print(the_header)
  #     print(length(the_header))
  
  # convert to CSV, without header
  tC <- textConnection(paste(the_data, collapse='\n'))
  the_data <- read.csv(tC, as.is=TRUE, row.names=NULL, header=FALSE, skip=1) #makes it a data.frame
  close(tC)
  
  # assign column names
  names(the_data) <- the_header
  
  # convert Time column into properly encoded date time
  the_data$Time <- as.POSIXct(strptime(paste(date,the_data[[1]]), format='%Y-%m-%d %I:%M %p'))
  
  # remove UTC and software type columns
  the_data$DateUTC.br. <- NULL
  the_data$SoftwareType <- NULL
  
  # sort and fix rownames
  the_data <- the_data[order(the_data$Time), ] #sort the rows by increasing time
  row.names(the_data) <- 1:nrow(the_data) #give the dataframe rownames
  
  df <- the_data
  if(opt.temp.only) {
    df <- the_data[c("Time", "TemperatureF")]
  }
  # done
  return(df)
}



#' These are needed for the function above
#' @export
#' @param station is a valid 3-letter airport code or a valid Weather Station ID
#' 
#' @param start_date is a valid string representing a date in the past (YYYY-MM-DD, all numeric)
#' 
#' @param end_date is a a valid string representing a date in the past (YYYY-MM-DD, all numeric) and is greater than start_date
#' 
#' 
IsStationDataAvailable<- function (station, station.type, start_date, end_date) {
  lst.start<- FetchDailyWeatherForStation(station, start_date, station.type, opt.temp.only=T, opt.compress.output=T)
  lst.end<- FetchDailyWeatherForStation(station, end_date, station.type, opt.temp.only=T, opt.compress.output=T)
  st.row = nrow(lst.start) #takes on a value of NULL if station has no data
  en.row = nrow(lst.end)
  
  cat(sprintf("For %s \n %d records for %s\n %d records for %s \n", station, st.row, start_date, en.row, end_date))
  
  if (is.integer(st.row) && is.integer(en.row))
  {
    return(1)
  }
  else {
    return(0) #nothing found
  }
}


#'  Getting data for full date-range
#'  @export
#'  
#'  @author Ram Narasimhan
#'  
#' @param station is a valid 3-letter airport code or a valid Weather Station ID
#' 
#' @param start_date is a valid string representing a date in the past (YYYY-MM-DD, all numeric)
#' 
#' @param end_date is a a valid string representing a date in the past (YYYY-MM-DD, all numeric) and is greater than start_date
#'  
#'  @param station.type = "airportCode" (3-letter airport code) or "ID" (Wx call Sign)

FetchStationWeatherForDateRange <- function(station, station.type, start.date, end.date) {
  
  validity = IsStationDataAvailable(station, station.type, start.date, end.date)
  if (validity==0){
    print(paste("Station data not available.", station, start.date, "to", "end.date"))
    return(0) #returning a NULL to signal no data
  }
  
  date.range <- seq.Date(from=as.Date(start.date), to=as.Date(end.date), by='1 day')
  print(station)
  # pre-allocate list
  l <- vector(mode='list', length=length(date.range))
  
  # loop over dates, and fetch data
  for(i in seq_along(date.range))
  {
    print(paste(station, i, date.range[i]))    
    l[[i]] <- FetchDailyWeatherForStation(station, date.range[i], station.type)
  }
  
  #print(l)  
  # stack elements of list into DF, filling missing columns with NA
  d <- ldply(l)
    
  outFileName = paste(station, "csv","gz", sep='.')
  # save to CSV
  write.csv(d, file=gzfile(outFileName), row.names=FALSE)
  print(paste("wrote:", outFileName, "to", getwd()))
}
