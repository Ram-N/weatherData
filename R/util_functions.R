readUrl <- function(final_url) {
  out <- tryCatch({
    #if you want to use more than one R expression in the "try" part use {}
    # 'tryCatch()' will return the last evaluated expression 
    # in case the "try" part was completed successfully  
    #message("This is the 'try' part")  
    u <- curl(final_url)
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
                  finally = close(u)
  # # NOTE:
  # # Here goes everything that should be executed at the end,
  # # regardless of success or error.
  # # If you want more than one expression to be executed, then you 
  # # need to wrap them in curly brackets ({...}); otherwise you could
  # # just have written 'finally=<expression>' 
  # }
  )    
  return(out)
}

keepOnlyMinMax <- function(single_day_df, 
                           daily_min=FALSE, 
                           daily_max=FALSE){
  ret <- NULL
  #assumes that second row is the value to get min/max of  
  min_row <- which.min(single_day_df[,2])
  max_row <- which.max(single_day_df[,2])
  
  Tmin <- single_day_df[min_row,1]
  Tmax <- single_day_df[max_row,1]
  Vmin <- single_day_df[min_row,2]
  Vmax <- single_day_df[max_row,2]
  if(daily_min)
    ret <- c(ret, Tmin, Vmin)
  if(daily_max)
    ret <- c(ret, Tmax, Vmax)
  return(ret)
  
}

#' Shows all the available Weather Data Columns
#' 
#' Displays all the columns that are available in the website, for the given
#' station, and date range. Useful when only a subset of the columns are
#' desired. Those can be specfied using the \code{custom_columns} vector.
#' Note: There are different columns available for summarized vs. detailed
#' data. Be sure toturn the \code{opt_detailed} flag to be TRUE if multiple
#' records per day is desired.
#' @param station_id is a valid 3-letter airport code or a valid Weather Station ID
#' @param start_date string representing a date in the past ("YYYY-MM-DD")
#' @param end_date string representing a date in the past ("YYYY-MM-DD"), and later than or equal to start_date.
#' @param station_type can be \code{airportCode} which is the default, or it
#'  can be \code{id} which is a weather-station ID
#' @param opt_detailed Boolen flag to indicate if detailed records for the station are desired.
#' (default FALSE). By default only one record per date is returned.
#' @param opt_verbose Boolean flag to indicate if verbose output is desired (default FALSE)
#' @examples
#' \dontrun{
#' showAvailableColumns("NRT", "2014-04-04")
#' 
#' #if you want to see the columns for the *detailed* weather, turn on opt_detailed
#' showAvailableColumns("CDG", "2013-12-12", opt_detailed=T)
#' }
#' @export
showAvailableColumns<- function(station_id, 
                                start_date, 
                                end_date =NULL,
                                station_type="airportCode",
                                opt_detailed = FALSE,                
                                opt_verbose=FALSE) {
  
  #fetch the data
  if(opt_detailed==TRUE){
    df <- getDetailedWeather(station_id,start_date,station_type,opt_all_columns=T)
  }else{
    df <- getSummarizedWeather(station_id,
                               start_date,end_date,
                               station_type,
                               opt_all_columns=TRUE)
  }

  #print only the header...as a dataframe
  #Dropping the first Column since it is not present in the web-page. 
  #Time Column was added by the getSummarizedWeather function
  named_df <- data.frame("columnNumber" = 1:(ncol(df)-1), 
                         "columnName" = names(df)[-1])    
  return(named_df)
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
#'  calling \code{getDetailedWeather()})
#' }
#' 
#' @references For a world-wide list of possible stations, be sure to look at
#' \url{http://weather.rap.ucar.edu/surface/stations.txt} The ICAO (4-letter
#' code is what needs to be input to \code{getDetailedWeather()})
#' 
#'@examples 
#' getStationCode("Fiji") 
#' getStationCode("Athens", region="GA") # in the US State of Georgia
#'
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

createWU_SingleDateURL <- function (station, 
                                   date, 
                                   station_type="airportCode",
                                   opt_verbose=FALSE) {
  # for Internal use only called by getDetailedWeather()
  date <- as.Date(date)
  m <- as.integer(format(date, '%m'))
  d <- as.integer(format(date, '%d'))
  y <- format(date, '%Y')

  station_type <- tolower(station_type)  
  if(IsStationTypeInvalid(station_type)) {
    return(NULL)
  }

  # compose final url
  # Type can be ID OR Airport  
  if(station_type=="id") {
    base_url <- 'https://www.wunderground.com/weatherstation/WXDailyHistory.asp?'
    final_url <- paste0(base_url,
                        'ID=', station,
                        '&month=', m,
                        '&day=', d, 
                        '&year=', y,
                        '&format=1')    
  }

  #for airport codes
  if(station_type=="airportcode") {
    airp_url = 'https://www.wunderground.com/history/airport/'
    coda = '/DailyHistory.html?format=1'    

    #If an airportLetterCode is not supplied, try with K
    #If it is, just use that code
    #letterCode <- ifelse(nchar(station) == 3, "K", "")

    final_url <- paste0(airp_url, #letterCode, 
                        station,
                        '/',y,
                        '/',m,
                        '/',d,
                        coda)
  }

  if(opt_verbose) {
    message(sprintf("Getting data from:\n %s\n",final_url))
    #message(sprintf("%s %s \n",letterCode, station))    
  }

  return(final_url)
}

# Internal utility function
#called by cleanAndSubetData()
getDesiredColumnsVector<- function(wx_df,
                                   time_column_number, #to be always returned
                                   opt_temperature_columns, 
                                   opt_all_columns, 
                                   opt_custom_columns, 
                                   custom_columns=NULL,
                                   opt_verbose=FALSE) {

  desired_columns <- vector()
  #check for internal consistency among selected options
  if(opt_custom_columns ==FALSE & opt_all_columns==FALSE & 
       opt_temperature_columns==FALSE){
    stop("\nAll 3 options: opt_custom_columns, opt_all_columns & opt_temperature_columns cannot be FALSE. \nNo columns to return. \nPlease select an option for desired columns")
    return(NULL)
  }

  if(opt_custom_columns ==TRUE & opt_all_columns==TRUE){
    message("\n Please note: Custom columns and opt_all_columns are both selected. \n Only custom columns will be returned.")
    opt_all_columns=FALSE
  }

  if(opt_temperature_columns ==TRUE & opt_all_columns==TRUE & opt_verbose){
    message("opt_all_columns takes precedence over opt_temperature_columns")
    opt_temperature_columns=FALSE
  }

  if(opt_temperature_columns ==TRUE & opt_custom_columns==TRUE & opt_verbose){
    message("opt_custom_columns takes precedence over opt_temperature_columns")
    opt_temperature_columns=FALSE
  }

  if(opt_custom_columns ==TRUE & is.null(custom_columns)){
    stop("\n\nCustom columns can't be NULL if opt_custom_columns is selected")
    return(NULL)
  }

  if(opt_custom_columns ==FALSE & !is.null(custom_columns)){
    stop("\n\nCustom columns can't be Specified 
         if opt_custom_columns is FALSE\n
         Please turn opt_custom_columns to be TRUE")    
    return(NULL)
  }

  # this will always be returned
  # time_column_number <- grep("Date", names(wx_df))

  #return custom_columns_only
  if(opt_custom_columns){
    desired_columns <- c(time_column_number, custom_columns)  
  } else if(opt_all_columns){
    #return all columns, moving Date column to be the first
    all_columns <- 1:length(wx_df)
    desired_columns <- c(time_column_number, all_columns[-time_column_number]) 
  }else{
    #return Temp columns only  
    desired_columns <- c(time_column_number, grep("Temperature", names(wx_df)))  
  }

  #remove duped columns
  dc <- desired_columns[!duplicated(desired_columns)]
  return(dc)
}

#for Internal use only                           
createWU_Custom_URL <- function (station, 
                                 start_date, 
                                 end_date,
                                 station_type="airportCode",
                                 opt_verbose=FALSE) {

  if(IsDateInvalid(start_date) | IsDateInvalid(end_date)) {
    return(NULL)
  }

  st_date <- as.Date(start_date)
  m <- as.integer(format(st_date, '%m'))
  d <- as.integer(format(st_date, '%d'))
  y <- format(st_date, '%Y')

  en_date <- as.Date(end_date)
  me <- as.integer(format(en_date, '%m'))
  de <- as.integer(format(en_date, '%d'))
  ye <- format(en_date, '%Y')

  station_type <- tolower(station_type)  
  if(IsStationTypeInvalid(station_type)) {
    return(NULL)
  }

  # compose final CUSTOM url
  #this part needs to be verified for custom History with WU
  if(station_type=="id") {# Type can be ID OR Airport      
    base_url <- 'https://www.wunderground.com/weatherstation/WXDailyHistory.asp?'
    final_url <- paste0(base_url,
                        'ID=', station,
                        '&month=', m,
                        '&day=', d, 
                        '&year=', y,
                        '&dayend=', de,
                        '&monthend=', me,
                        '&yearend=', ye,                                                
                        '&graphspan=custom&format=1')
  }

  #for airport codes
  if(station_type=="airportcode") {
    airp_url = 'https://www.wunderground.com/history/airport/'
    mid = '/CustomHistory.html?'
    coda = '&req_city=NA&req_state=NA&req_statename=NA&format=1'

    #If an airportLetterCode is not supplied, try with K
    #If it is 4 letters, just use the supplied 
    #letterCode <- ifelse(nchar(station) == 3, "K", "")

    final_url <- paste0(airp_url, # letterCode, 
                        station,
                        '/',y,
                        '/',m,
                        '/',d,
                        mid,
                        'dayend=', de,
                        '&monthend=', me,
                        '&yearend=', ye,                        
                        coda)
  }

  if(opt_verbose) {
    message(sprintf("URL to Try:\n %s\n",final_url))
    #message(sprintf("%s %s \n",letterCode, station))    
  }

  return(final_url)
}

#for internal use only
convertTimeStringToTimeStamp <- function(time_vec, date){

  #There are two possible formats.
  # In 1. The date is separate, and the time comes from the first column
  # In 2. The timestamp contains it all

  time_stamp <- time_vec[1]
  if(!is.na(as.POSIXct(strptime(paste(date, time_vec[1]), 
                                format='%Y-%m-%d %I:%M %p')))){
    time_vec <- as.POSIXct(paste(date, time_vec), format='%Y-%m-%d %I:%M %p')
  } else if(!is.na(as.POSIXct(time_stamp, format='%Y-%m-%d %H:%M:%S'))) {
    time_vec <- as.POSIXct(time_vec, format='%Y-%m-%d %H:%M:%S')
  }
  #it is isn't any of the above formats, just return the vector
  return(time_vec)  
}

#for internal use only
cleanAndSubsetObtainedData<- function(wxdata, 
                                      opt_temperature_columns=TRUE,
                                      opt_all_columns=FALSE,
                                      opt_custom_columns=FALSE,
                                      custom_columns=NULL,
                                      opt_verbose=FALSE){
  #no need to trim rows if summarized data. All rows are needed.

  # remove the first line if blank. It is always a blank.
  if(wxdata[1]=="") {
    wxdata <- wxdata[-c(1)]    #remove first element of vector    
  }

  #get rid of the trailing br at the end of each line
  wxdata <- gsub("<br />", "", wxdata) 
  #the following are harmless if not present
  wxdata <- gsub("<br>", "", wxdata) #get rid of BR tags
  wxdata <- wxdata[wxdata!=""] #remove blank lines (if any)
  wxdata <- sub(",+$", "", wxdata) #remove ENDING commas (if any)

  if(opt_verbose){print(length(wxdata))}

  # extract Column Header names
  header_row <- wxdata[1] #wxdata is a chr vector
  header_names <- strsplit(header_row, ',')[[1]]
  header_names <- gsub("^ ", "", header_names) #get rid of leading blanks
  header_names <- make.names(header_names)
  header_names <- gsub("\\.", "_", header_names)

  #make the col.names syntactically valid
  if(opt_verbose ==TRUE){
    message("The following columns are available:")
    print(header_names)    
  }

  # convert to csv, skipping header (first element)
  tC <- textConnection(paste(wxdata, collapse='\n'))
  wx_df <- read.csv(tC, as.is=TRUE, row.names=NULL, header=FALSE, skip=1) #makes it a data frame
  close(tC)  

  # assign column and row names
  names(wx_df) <- header_names
  row.names(wx_df) <- 1:nrow(wx_df) #give the dataframe rownames

  if(opt_verbose){
    message("Preview of the data available...")
    print(dim(wx_df))
    print(head(wx_df))
  }

  # we now have a good df to work with.
  # -------------------------------------------------------------  
  # create a clean column of Dates
  # In summarized, there is no timestamp, only DateStamp
  wx_df$CleanDate <- strptime(wx_df[,1], format='%Y-%m-%d')
  time_column_number <- length(wx_df)

  # sort by Time
  wx_df <- wx_df[order(wx_df$CleanDate), ] #sort the rows, ordered by increasing time  
  time_column_number <- grep("CleanDate", names(wx_df))[1] #find the column number
  names(wx_df)[time_column_number] <- "Date" #rename it back

  ##----------------------------------------------------------
  # subset Columns
  ##----------------------------------------------------------
  desired_columns <-  getDesiredColumnsVector(wx_df,
                                              time_column_number,                                              opt_temperature_columns, 
                                              opt_all_columns, 
                                              opt_custom_columns, 
                                              custom_columns,
                                              opt_verbose) 

  if(opt_verbose) {
    message("Desired Columns Requested:")
    print(desired_columns)    
  }

  if(desiredColumnsAreValid(wx_df, desired_columns))
    return(wx_df[,desired_columns])
  else
    return(NULL)
  
  return(wx_df[,desired_columns])
}

#for internal use only
cleanAndSubsetDetailedData<- function(wxdata, 
                                      date,
                                      opt_temperature_columns=TRUE,
                                      opt_all_columns=FALSE,
                                      opt_custom_columns=FALSE,
                                      custom_columns=NULL,
                                      opt_compress_output=FALSE,
                                      opt_verbose=FALSE){
  
  # remove the first line if blank. It is always a blank.
  if(wxdata[1]=="") {
    wxdata <- wxdata[-c(1)]    #remove first element of vector    
  }

  #get rid of the trailing br at the end of each line
  wxdata <- gsub("<br />", "", wxdata) 

  wxdata <- gsub("<br>", "", wxdata) #get rid of BR tags
  wxdata <- wxdata[wxdata!=""] #remove blank lines (if any)
  wxdata <- sub(",+$", "", wxdata) #remove ENDING commas (if any)

  if(opt_verbose){print(length(wxdata))}
  
  if(opt_compress_output==TRUE) {
    # remove odd rows starting from 3, in order to reduce volume
    wxdata <- wxdata[-seq(3, length(wxdata), by=2)]    
  }
  
  # extract Column Header names
  header_row <- wxdata[1] #wxdata is a chr vector
  header_names <- strsplit(header_row, ',')[[1]]
  header_names <- gsub("^ ", "", header_names) #get rid of leading blanks
  header_names <- make.names(header_names)
  header_names <- gsub("\\.", "_", header_names)
  
  #make the col.names syntactically valid
  if(opt_verbose ==TRUE)    {
    message("The following columns are available for:", date)
    print(header_names)    
  }
  
  #wxdata$DateUTC.br. <- NULL
  #wxdata$SoftwareType <- NULL
  
  
  # convert to csv, skipping header (first element)
  tC <- textConnection(paste(wxdata, collapse='\n'))
  wx_df <- read.csv(tC, as.is=TRUE, row.names=NULL, header=FALSE, skip=1) #makes it a data frame
  close(tC)  
  
  if(opt_verbose){
    print(dim(wx_df))
    print(head(wx_df))
  }
  
  
  # assign column and row names
  names(wx_df) <- header_names
  row.names(wx_df) <- 1:nrow(wx_df) #give the dataframe rownames
  
  # We now have a good df to work with.
  # -------------------------------------------------------------  
  # convert Time column into properly encoded date time
  
  #' need to find the Format of the Time stamp first.
  #' It could be one of two formats...
  #' If neither, then don't convert..
  
  wx_df$DateTime <- convertTimeStringToTimeStamp(wx_df[[1]], date)
  #wx_df$DateTime <- as.POSIXct(strptime(paste(date,wx_df[[1]]), format='%Y-%m-%d %I:%M %p'))
  
  # sort by Time
  wx_df <- wx_df[order(wx_df$DateTime), ] #sort the rows, ordered by increasing time
  time_column <- grep("DateTime", names(wx_df))[1] #find the column number
  names(wx_df)[time_column] <- "Time" #rename it back
  
  
  ##----------------------------------------------------------
  #subset Columns
  ##----------------------------------------------------------
  desired_columns <-  getDesiredColumnsVector(wx_df,
                                              time_column,
                                              opt_temperature_columns, 
                                              opt_all_columns, 
                                              opt_custom_columns, 
                                              custom_columns,
                                              opt_verbose) 
  
  
  if(opt_custom_columns & opt_verbose) {
    message("Desired Columns Requested:")
    print(desired_columns)    
  }
  
  if(desiredColumnsAreValid(wx_df, desired_columns))
    return(wx_df[,desired_columns])
  else
    return(NULL)
}
