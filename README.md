# ropenweather
[![R Package Build ropenweather](https://github.com/marinatian/534project/actions/workflows/r.yml/badge.svg)](https://github.com/marinatian/534project/actions/workflows/r.yml)
## Introduction

ropenweather is an R package designed for fetching, processing, and visualizing weather data from the OpenWeatherMap API. This vignette demonstrates how to use its functionalities effectively.

## Installation

To install the latest version of `ropenweather` from GitHub, use:

```{r}
# install.packages("devtools")
devtools::install_github("marinatian/534project")
```

Load `ropenweather`

```{r}
library('ropenweather')
```

Before using the package, ensure you have an API key from OpenWeatherMap. Store your API key as follows:
```{r}
api_key <- "f4ae84f3cc4c51353a1ae2279dd7a60b" # Replace with your actual API key
```

## Fetching
### Current Weather
To get current weather information for a specific location:
```{r}
lat <- 40.7128  # Example latitude for New York City
lon <- -74.0060 # Example longitude for New York City
current_weather <- get_current_weather(lat, lon, api_key)
```

### Weather Forecast
```{r}
forecast_weather <- get_forecast_weather(lat, lon, api_key)
```

## Processing Weather Data
### Current Weather
Process the fetched current weather data:
```{r}
processed_current <- process_current_weather(current_weather)

```

### Weather Forecast
Process the fetched forecast weather data:
```{r}
processed_forecast <- process_forecast_weather(forecast_weather)
```

## Data Visualization
### Visualizing Current Weather
Visualize the current weather conditions:
```{r}
visualize_current_weather(processed_current)
```

### Visualizing Weather Forecast
Create visualizations for the weather forecast:
```{r}
visualize_forecast_weather(processed_forecast)
```

## Features
Fetch current weather and forecast data using latitude and longitude.  
Process the raw data into a user-friendly format.  
Visualize weather data with built-in plotting functions.
