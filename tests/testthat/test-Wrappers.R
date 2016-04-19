context("Wrapper Functions")

test_that("Wrapper: GetDataForYear", {
  df <- getWeatherForYear("FCO", 2013)
  expect_that(df, is_a("data.frame"))
  expect_equal(ncol(df), 4)
  expect_equal(nrow(df), 365)
  expect_equal(grep(df$Date[365], "2013-12-31"), 1)  
})
