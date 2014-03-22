context("SummarizedWeather")



test_that("Get the right number of rows", {
  df <- getSummarizedWeather("LHR", "2012-01-01", "2012-02-01", 
                                      opt_custom_columns=T, 
                                      custom_columns=c(24,2, 24))
  expect_that(nrow(df), equals(32))
  expect_that(ncol(df), equals(2))
})

# test_that("floor_date works for different units", {
#   base <- as.POSIXct("2009-08-03 12:01:59.23", tz = "UTC")
#   is_time <- function(x) equals(as.POSIXct(x, tz = "UTC"))
#   floor_base <- function(unit) floor_date(base, unit)
#   expect_that(floor_base("second"), is_time("2009-08-03 12:01:59"))
#   expect_that(floor_base("minute"), is_time("2009-08-03 12:01:00"))
# })