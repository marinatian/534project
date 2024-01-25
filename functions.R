library(httr)
library(jsonlite)
library(ggplot2)
library(plotly) 
library(shiny) 
library(dplyr)

# 1. Get the weather data
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

api_key <- 'f4ae84f3cc4c51353a1ae2279dd7a60b'

# Example for London, UK 
current_weather <- get_current_weather(51.5074, -0.1278, api_key)
forecast_weather <- get_forecast_weather(51.5074, -0.1278, api_key)


# 2. Data processing
# Process Current Weather Data
current_weather_processed <- list(
  temperature = current_weather$temp,
  weather = current_weather$weather$description,
  humidity = current_weather$humidity,
  wind_speed = current_weather$wind_speed
)

# Process Forecast Weather Data
forecast_weather_processed <- lapply(seq_len(nrow(forecast_weather)), function(i) {
  day_forecast <- forecast_weather[i, ]
  list(
    day = as.Date(as.POSIXct(day_forecast$dt, origin = "1970-01-01", tz = "UTC")),
    weather = day_forecast$summary,
    temp_min = day_forecast$temp$min,
    temp_max = day_forecast$temp$max,
    humidity = day_forecast$humidity
  )
})


# 3. Data visualization
# visualize current weather data
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




# 4. Data formatting
# Combine processed data into one list
combined_weather_data <- list(
  current_weather = current_weather_processed,
  forecast_weather = forecast_weather_processed
)

# Convert the combined data to JSON
json_weather_data <- jsonlite::toJSON(combined_weather_data, pretty = TRUE, auto_unbox = TRUE)




# Call the function with processed forecast data
visualize_forecast_weather(forecast_weather_processed)
visualize_current_weather(current_weather_processed)

# Write the JSON data to a file
write(json_weather_data, file = "weather_data.json")
