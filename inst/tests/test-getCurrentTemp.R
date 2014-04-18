context("Current Temperature")

test_that("Get the Current Temperature of a Location", {
  ctInd <- getCurrentTemperature("IND")
  
  expect_that(ctInd, is_a("data.frame"))
  expect_that(ctInd$Time, is_a("POSIXct"))
  
})