#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom ggplot2 ggplot aes geom_bar labs theme_minimal geom_line scale_color_manual position_dodge
#' @importFrom dplyr bind_rows
#'
#'
# 1. Get the weather data
#' @title title get_current_weather
#' @param lat A number.
#' @param lon Another number.
#' @param api_key Another number.
#' @return current_weather.
#' @export
get_current_weather <- function(lat, lon, api_key) {
  base_url <- "https://api.openweathermap.org/data/3.0/onecall"
  response <- GET(url = base_url, query = list(lat = lat, lon = lon, appid = api_key, units = "metric"))

  if (status_code(response) != 200) {
    stop("Error: ", content(response, "text"), call. = FALSE)
  }

  weather_data <- fromJSON(rawToChar(response$content))
  current_weather <- weather_data$current
  return(current_weather)
}

#' @title title get_forecast_weather
#' @param lat A number.
#' @param lon Another number.
#' @param api_key Another number.
#' @return forecast_weather.
#' @export
get_forecast_weather <- function(lat, lon, api_key) {
  base_url <- "https://api.openweathermap.org/data/3.0/onecall"
  response <- GET(url = base_url, query = list(lat = lat, lon = lon, appid = api_key, units = "metric"))

  if (status_code(response) != 200) {
    stop("Error: ", content(response, "text"), call. = FALSE)
  }

  weather_data <- fromJSON(rawToChar(response$content))
  forecast_weather <- weather_data$daily
  return(forecast_weather)
}



# 2. Data processing
# Process Current Weather Data
#' @title process_current_weather
#' @param current_weather A number.
#' @return process_current_weather.
#' @export
process_current_weather <- function(current_weather) {
  if (is.null(current_weather)) {
    stop("No current weather data available", call. = FALSE)
  }

  list(
    temperature = current_weather$temp,
    weather = current_weather$weather$description,
    humidity = current_weather$humidity,
    wind_speed = current_weather$wind_speed
  )
}

# Process Forecast Weather Data
#' @title process_forecast_weather
#' @param forecast_weather A number.
#' @return process_forecast_weather.
#' @export
process_forecast_weather <- function(forecast_weather) {
  if (is.null(forecast_weather)) {
    stop("No forecast weather data available", call. = FALSE)
  }

  lapply(seq_len(nrow(forecast_weather)), function(i) {
    day_forecast <- forecast_weather[i, ]
    list(
      day = as.Date(as.POSIXct(day_forecast$dt, origin = "1970-01-01", tz = "UTC")),
      weather = day_forecast$summary,
      temp_min = day_forecast$temp$min,
      temp_max = day_forecast$temp$max,
      humidity = day_forecast$humidity
    )
  })
}

# 3. Data visualization
# visualize current weather data
#' @title visualize_current_weather
#' @param current_weather_processed A number.
#' @return visualize_current_weather.
#' @export
visualize_current_weather <- function(current_weather_processed) {
  data <- data.frame(
    variable = c("Temperature", "Humidity", "Wind Speed"),
    value = c(current_weather_processed$temperature,
              current_weather_processed$humidity,
              current_weather_processed$wind_speed)
  )

  ggplot(data, aes(x = variable, y = value, fill = variable)) +
    geom_bar(stat = "identity", position = position_dodge()) +
    labs(title = "Current Weather Conditions", x = "", y = "") +
    theme_minimal()
}

# visual forecast weather data
#' @title visualize_forecast_weather
#' @param forecast_weather_processed A number.
#' @return visualize_forecast_weather.
#' @export
visualize_forecast_weather <- function(forecast_weather_processed) {
  forecast_df <- bind_rows(forecast_weather_processed)
  temp_plot <- ggplot(forecast_df, aes(x = day)) +
    geom_line(aes(y = temp_min, color = "Min Temperature")) +
    geom_line(aes(y = temp_max, color = "Max Temperature")) +
    labs(title = "Temperature Forecast", x = "Day", y = "Temperature (°C)") +
    theme_minimal() +
    scale_color_manual("",
                       breaks = c("Min Temperature", "Max Temperature"),
                       values = c("darkblue", "steelblue"))

  print(temp_plot)
  humidity_plot <- ggplot(forecast_df, aes(x = day, y = humidity)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    labs(title = "Humidity Forecast", x = "Day", y = "Humidity (%)") +
    theme_minimal()

  print(humidity_plot)
}
