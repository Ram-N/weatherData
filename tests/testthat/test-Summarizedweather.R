context("SummarizedWeather")



test_that("Get the right number of rows", {
  df <- getSummarizedWeather("LHR", "2012-01-01", "2012-02-01", 
                                      opt_custom_columns=T, 
                                      custom_columns=c(24,2, 24))
  expect_that(nrow(df), equals(32))
  expect_that(ncol(df), equals(2))
})

test_that("Summarized: Get Temp columns by default", {
  LA <- getSummarizedWeather("LAX", "2014-01-01", "2014-01-31")
  expect_that(LA, is_a("data.frame"))
  expect_equal(ncol(LA), 4)
  expect_equal(nrow(LA), 31)
})

test_that("Summarized: Get Temp columns by default", {
  windLHR <- getSummarizedWeather("LHR", "2012-12-12", "2012-12-12", 
                                  opt_custom_columns=TRUE,
                                  custom_columns=c(17,18,19,23))
  expect_that(windLHR, is_a("data.frame"))
  expect_equal(ncol(windLHR), 5)
  expect_equal(windLHR$WindDirDegrees, 104)
})


test_that("Summarized for a single date", {
  sfo_single_date<- getSummarizedWeather("SFO", "2013-03-31")
  expect_that(sfo_single_date, is_a("data.frame"))
  expect_equal(ncol(sfo_single_date), 4)
  expect_equal(nrow(sfo_single_date), 1)
})



