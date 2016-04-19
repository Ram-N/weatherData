context("DetailedWeather")

test_that("Data is available for MCI", {
  cDA <- checkDataAvailabilityForDateRange("MCI", 
                                    "2013-02-02", 
                                    "2014-01-01")
  expect_equal(cDA, 1)
  })

test_that("Must supply a date", {
  expect_error(
    getDetailedWeather("KBUF"), '"date" is missing'
  )
})
