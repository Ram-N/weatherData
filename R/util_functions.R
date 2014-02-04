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




