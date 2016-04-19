#' @title Gets weather data for a single date (All records)
#' 
#' @description Given a valid station and a single date this function
#'  will return a dataframe of time-stamped weather data. It does not summarize
#'  the data.
#'  
#' @param station_id is a valid 3-letter airport code or a valid Weather Station ID
#' @param date is a valid string representing a date in the past (YYYY-MM-DD)
#' @param station_type can be \code{airportCode} which is the default, or it
#'  can be \code{id} which is a weather-station ID
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
#' @param opt_compress_output Boolean flag to indicate if a compressed output is preferred. 
#'  If this option is set to be TRUE, only every other record is returned
#' @param opt_verbose Boolean flag to indicate if verbose output is desired
#' @param opt_warnings Boolean flag to turn off warnings. Default value is TRUE, to keep
#' the warnings on.
#' @seealso getWeatherForDate, getSummarizedWeather

#' @return A data frame with each row containing: \itemize{
#' \item Date and Time stamp for the date specified
#' \item Temperature and/or other weather columns 
#' }
#'@examples
#'\dontrun{
#' getDetailedWeather("NRT", "2014-04-29") #just the Temperature Columns
#' 
#' # Returns all columns available
#' getDetailedWeather("NRT", "2014-04-29", opt_all_columns=T) 
#' 
#' wCDG <- getDetailedWeather("CDG", "2013-12-12",opt_custom_columns=T, 
#'                            custom_columns=c(10,11,12))
#'}
#' @export
getDetailedWeather <- function(station_id, 
                               date, 
                               station_type="airportCode",
                               opt_temperature_columns=TRUE,
                               opt_all_columns=FALSE,
                               opt_custom_columns=FALSE,
                               custom_columns=NULL,
                               opt_compress_output=FALSE,
                               opt_verbose=FALSE,
                               opt_warnings=TRUE) {

  #validate Inputs
  if(IsDateInvalid(date, opt_warnings)) {
    if (opt_warnings)
      warning(sprintf("Unable to build a valid URL \n Date format Invalid %s \n Input date should be within quotes \n and of the form 'YYYY-MM-DD' \n\n", date))     
    return(NULL)
  }  
  station_type <- tolower(station_type)
  if(IsStationTypeInvalid(station_type)) {
    warning("Station Type is Invalid:", station_type)
    return(NULL)
  }

  # Create the WxUnderground URL
  final_url <- createWU_SingleDateURL(station_id, date, station_type, opt_verbose)

  #------------------
  # Now read the data from the URL
  #-------------------  
  # reading in as raw lines from the web server
  # contains <br> tags on every other line
  wxdata <- readUrl(final_url)

  # check that the results are usable
  if(grepl(pattern="No daily or hourly history data", wxdata[3]) ==TRUE){
    if(opt_warnings) {
      warning(sprintf("Unable to get data from URL
                  \n Check Station name %s 
                  \n Check If Date is in the future %s
                  \n Inspect the validity of the URL being tried:\n %s \n", station_id, date, final_url))
      message("For Airports, try the 4-letter Weather Airport Code")  
    }
    return(NULL)      
  }
  
  # check that the results are usable
  
  if(is.na(wxdata[1])) {
    warning(sprintf("Unable to get data from URL\n Check if URL is reachable"))
    return(NULL) #have to try again
  }

  #Clean the data frame
  # only keep records with more than 3 rows of data
  if(length(wxdata) < 3 ) {
    warning(paste("not enough records found for", station_id, 
                "\n Only", length(wxdata), "records."))
    return(NULL)
  }

  df <- cleanAndSubsetDetailedData(wxdata, 
                                    date,
                                    opt_temperature_columns,
                                    opt_all_columns,
                                    opt_custom_columns,
                                    custom_columns,
                                    opt_compress_output,
                                    opt_verbose)
  
  return(df)  
    
}






#' @title Gets daily summary weather data (One record per day)
#' 
#' @description Given a valid station and a single date this function
#'  will return a dataframe of time-stamped weather data. All the records
#'  are summarized into one record per day. If and \code{end_date} is specified
#'  the function returns 1 record for each day in the date range.
#'  
#' @param station_id is a valid 3-letter airport code 
#' @param start_date string representing a date in the past ("YYYY-MM-DD")
#' @param end_date (optional) string representing a date in the past ("YYYY-MM-DD"), and later than or equal to start_date.
#' @param station_type can be \code{airportCode} which is the default, or it
#'  can be \code{id} which is a weather-station ID
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
#' @param opt_verbose Boolean flag to indicate if verbose output is desired
#' @seealso getWeatherForDate, getDetailededWeather
#' 
#' @return A data frame with each row containing: \itemize{
#' \item Date stamp for the date specified
#' \item Additional columns of Weather data depending on the options specified 
#' }
#' 
#'@examples
#'\dontrun{
#' paris_in_fall<- getSummarizedWeather("CDG", "2013-09-30") #will get Temp columns by default
#' #
#' windLHR <- getSummarizedWeather("LHR", "2012-12-12", "2012-12-31", 
#'                                  opt_custom_columns=TRUE, 
#'                                  custom_columns=c(17,18,19,23))
#'                                  
#'}
#' @export
getSummarizedWeather <- function(station_id, 
                                 start_date, 
                                 end_date=NULL,
                                 station_type="airportCode",
                                 opt_temperature_columns=TRUE,
                                 opt_all_columns=FALSE,
                                 opt_custom_columns=FALSE,
                                 custom_columns=NULL,
                                 opt_verbose=FALSE){
  
  if(is.null(end_date)) end_date <- start_date
  if(!validInputParameters(start_date, 
                           end_date,
                           station_type)){
    stop("\nInput parameters Invalid.")
    return(NULL)
  }

  custom_url <- createWU_Custom_URL(station_id, 
                                    start_date, 
                                    end_date,
                                    station_type,
                                    opt_verbose)
  if(opt_verbose){
    message(sprintf("Retrieving from: %s", custom_url))    
  }  
  wxdata <- readUrl(custom_url)
  if(!isObtainedDataValid(wxdata, station_id, custom_url)) return(NULL)
  
  df <- cleanAndSubsetObtainedData(wxdata,
                                   opt_temperature_columns,
                                   opt_all_columns,
                                   opt_custom_columns,
                                   custom_columns,
                                   opt_verbose)
    
  return(df)
}
