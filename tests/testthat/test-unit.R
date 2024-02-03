#  API Key Management

#Successful API Call
test_that("get_current_weather returns correct structure for valid input", {
  # Assuming you have a function to mock API responses
  result <- get_current_weather(lat = 51.5074, lon = -0.1278, api_key = "f4ae84f3cc4c51353a1ae2279dd7a60b")
  expect_type(result, "list")
  expect_true("temp" %in% names(result))
})


#
# HTTP Error Handling
test_that("get_current_weather handles 401 error gracefully", {
  # Mock a 401 response
  expect_error(get_current_weather(lat = 51.5074, lon = -0.1278, api_key = "test_api_key"), "401")
})

# Data Processing
test_that("current_weather_processed formats data correctly", {
  mock_data <- list(temp = 15, weather = data.frame(description = "clear sky"), humidity = 50, wind_speed = 5)
  processed <- process_current_weather(mock_data)
  expect_equal(processed$temperature, 15)
  expect_equal(processed$weather, c("clear sky"))
})

# Visualization Functions
test_that("visualize_current_weather creates a ggplot", {
  mock_data <- list(temperature = 20, weather = "clear sky", humidity = 50, wind_speed = 5)
  plot <- visualize_current_weather(mock_data)
  expect_true(inherits(plot, "ggplot"))
})
