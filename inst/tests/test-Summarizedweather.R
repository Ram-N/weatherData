context("SummarizedWeather")



test_that("Must supply a date", {
  expect_equal(
    nrow(getSummarizedWeather("VOBB",
                             "2010-01-01", 
                             "2012-01-02",
                             opt_all_columns=T,
                             opt_custom_columns=T,
                             custom_columns=c(2,3,4))),
    365
  )
})


# test_that("expectation is additive", {
#   expect_equal(E(dice + dice), 2 * E(dice))
#   expect_equal(E(dice + dice + dice), 3 * E(dice))
# })
# 
# test_that("expectation is multiplicatve", {
#   expect_equal(E( 6 * dice),  6 * E(dice))
#   expect_equal(E( 1 * dice),  1 * E(dice))
#   expect_equal(E(-1 * dice), -1 * E(dice))
#   expect_equal(E( 0 * dice),  0 * E(dice))
# })
