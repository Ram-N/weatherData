context("Custom Columns")

test_that("Which Columns are available", {
  sAC <- showAvailableColumns("KIX", "2014-04-04")
  expect_that(sAC, is_a("data.frame"))
  expect_equal(ncol(sAC), 2)
  expect_equal(nrow(sAC), 23)
})

