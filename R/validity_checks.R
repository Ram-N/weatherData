IsDateInvalid <- function (date, opt_warnings=TRUE) {
  # d <- try( as.Date( date, format= "%d-%m-%Y %H:%M:%S" ) ) #original
  d <- try(as.Date(date))
  if( class(d) == "try-error" || is.na(d) ){
    stop(paste("\n\nInvalid date supplied:", date))
    return(1)
  }

  #If a date in the future is supplied, print an error message
  #return Invalid = TRUE
  if(date > Sys.Date()){
    if(opt_warnings)
      warning(paste("\n\nInput Date cannot be in the future:", date))
    return(1)
  }
  
  return(0) #is okay
}


isDateRangeValid <- function(start_date, end_date){
  
  if(IsDateInvalid(start_date)){
    return(0)
  }
  if(IsDateInvalid(end_date)){
    return(0)
  }
  
  if(start_date > end_date){
    stop(paste("Start Date cannot be after End Date:",start_date, end_date))  
    return(0)
  }
  
  return(1)
}




validYear <- function(year){
  current_year = 1900 + as.POSIXlt(Sys.Date())$year    
  if(year <= 0){
    return(0)
  }    
  if(year > current_year){
    warning("\nThe year cannot be greater than current year.")
    return(0)
  }  
  return(1) #is okay
}


IsStationTypeInvalid <- function (station_type) {
  #has gone through to.lower
    if(station_type != "airportcode" &
         station_type != "id")  {
      warning(paste( "Invalid station_type supplied:", station_type ))
      warning(sprintf("Unable to build a valid URL \n 
                    station_type Invalid: %s \n 
                    Station types should be either 'airportCode' or 'ID' \n 
                    \n\n", station_type))     
      
      return(1)
    }
    return(0) #is okay
  }
  


#internal function. 
# Called by getSummarizedData
isObtainedDataValid <- function(wxdata, station_id, url){
  # check that the results are usable  
  pattern="No daily or hourly history data"
  
  if(length(wxdata) <=2){
    warning(sprintf("There seems to be no data in the URL.\nTry going to the URL via your browser and seeing if there is data.
                    \n Inspect the validity of the URL being tried:\n %s \n", url))
    return(0) #have to try again
  }
  
  # check if WU has anything usable
  if(grepl(pattern, wxdata[3]) ==TRUE){
    warning(sprintf("Unable to get data from URL
                    \n Check Station ID %s 
                    \n Inspect the validity of the URL being tried:\n %s \n", station_id, url))
    message("For Airports, try the 4-letter Weather Airport Code")  
    return(0)      
  }
  
  # check if the site reachable?  
  if(is.na(wxdata[1])) {
    warning(sprintf("Unable to get data from URL\n Check if URL is reachable"))
    return(0) #have to try again
  }
  
  return(1)
}

#for internal use only
#validation routine
#called from getSummarizedData
validInputParameters <- function(start_date, 
                                 end_date,
                                 station_type){
  
  if(!isDateRangeValid(start_date, end_date)) return(0)
  
  station_type <- tolower(station_type)
  if(IsStationTypeInvalid(station_type)) return(0)
  
  return(1)
}

#for internal use only
#validation routine
#called from cleanAndSubsetDetailedData
desiredColumnsAreValid <- function(wx_df, desired_columns){
#make sure that the desired columns vector has reasonable numbers.
  maxpossibleColNum <- ncol(wx_df)
  
  if (any(desired_columns > maxpossibleColNum)){
    print("custom_columns:")
    print(desired_columns)
    stop("Invalid Columns specified in custom_columns vector.\n
Specified column number is Larger than what is available columns: ", maxpossibleColNum)
    return (FALSE) #something is not valid
  }

  if (any(desired_columns < 0)){
    print("custom_columns:")
    print(desired_columns)
    stop("Invalid Columns (negative number) specified in custom_columns vector.")
    return (FALSE) #something is not valid
  }
  return (TRUE)
}
  


