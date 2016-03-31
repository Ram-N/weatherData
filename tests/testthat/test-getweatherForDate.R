context("getWeatherForDate")

test_that("Unreasonable Column Number Error", {
  expect_error(getWeatherForDate("CWWF", 
                         start_date="2014-03-01", 
                         end_date = "2014-03-03", 
                         opt_detailed = TRUE, 
                         opt_custom_columns=TRUE,
                         custom_columns=c(1, 3, 9, 18, 20, 23)) ,
  "Invalid Columns")
  })

# test_that("Just get everything Test", {
#   d3 <- getWeatherForDate("CWWF", 
#                           start_date="2014-03-01", 
#                           end_date = "2014-03-03", 
#                           opt_detailed = TRUE, 
#                           opt_all_columns = TRUE)
#   expect_is(d3, "data.frame", info = "data frame")
#   expect_equal(nrow(d3), 84, info = "84 rows")
#   expect_equal(ncol(d3), 15, info = "15 columns")
# })
