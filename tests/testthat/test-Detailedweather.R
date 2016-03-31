context("Detailed Weather")

test_that("Get the right number of rows", {
  df <- getDetailedWeather("GIG", "2012-03-14", opt_all_columns=TRUE)
  expect_is(df, "data.frame")
  expect_equal(nrow(df), 31)
  expect_equal(ncol(df), 15)
})

test_that("DetailedData: Get the Temp column by default", {
  LA <- getDetailedWeather("LAX", "2014-01-01")
  expect_is(LA, "data.frame")
  expect_equal(ncol(LA), 2)
  expect_equal(nrow(LA), 33)
})

test_that("Detailed: Get Custom columns", {
  wCDG <- getDetailedWeather("CDG", "2013-12-12",opt_custom_columns=T, 
                             custom_columns=c(10,11,12))
  expect_that(wCDG, is_a("data.frame"))
  expect_equal(ncol(wCDG), 4)
  expect_equal(nrow(wCDG), 48)
})


