# weatherData 0.5

* Added a `NEWS.md` file to track changes to the package.

* Fixed station_type = "ID" bug. Many features were not working.

* `curl` option takes care of 'https' (This has been on github for months.)

* Added a warning for multiple year fetches. (WeatherUnderground doesn't allow very large CSV files.)