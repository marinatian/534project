get_city_coordinates <- function(city_name, api_key) {
  base_url <- "http://api.openweathermap.org/data/2.5/weather"
  response <- GET(base_url, query = list(q = city_name, appid = api_key))

  if (status_code(response) == 200) {
    data <- content(response, "text", encoding = "UTF-8")
    data <- fromJSON(data)
    if ("coord" %in% names(data)) {
      latitude <- data$coord$lat
      longitude <- data$coord$lon
      return(c(latitude, longitude))
    } else {
      print("Coordinates not found for the city.")
    }
  } else {
    print(paste("Error:", content(response, "text", encoding = "UTF-8")))
  }
}

api_key <- "f4ae84f3cc4c51353a1ae2279dd7a60b"
city_name <- "Vancouver"
coordinates <- get_city_coordinates(city_name, api_key)
if (!is.null(coordinates)) {
  cat("Latitude:", coordinates[1], "\n")
  cat("Longitude:", coordinates[2], "\n")
}
