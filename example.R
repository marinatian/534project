api_key <- 'f4ae84f3cc4c51353a1ae2279dd7a60b'

# Example for London, UK
#current_weather <- get_current_weather(51.5074, -0.1278, api_key)
#forecast_weather <- get_forecast_weather(51.5074, -0.1278, api_key)

# Vancouver
current_weather <- get_current_weather(49.2497, -123.1193, api_key)
forecast_weather <- get_forecast_weather(49.2497, -123.1193, api_key)

# Toronto
current_weather <- get_current_weather(43.7001 , -79.4163, api_key)
forecast_weather <- get_forecast_weather(43.7001 , -79.4163, api_key)

current_weather_processed <- process_current_weather(current_weather)
forecast_weather_processed <- process_forecast_weather(forecast_weather)


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

