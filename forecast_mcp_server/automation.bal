import ballerina/mcp;

@mcp:StreamableHttpServiceConfig {
    info: {
        name: "Weather Forecast MCP Server",
        version: "1.0.0",
        description: "Provides weather related tools such as current conditions, forecasts, alerts, and historical data. All data returned is dummy data for demonstration purposes."
    }
}
service mcp:StreamableHttpService /weather on new mcp:StreamableHttpListener(8080) {

    # Get the current weather conditions for a location.
    #
    # + location - The city or place name to get current weather for
    # + return - The current weather conditions, or an error if the request fails
    remote function getCurrentWeather(string location) returns CurrentWeather|error {
        return buildCurrentWeather(location);
    }

    # Get a multi-day weather forecast for a location.
    #
    # + location - The city or place name to get the forecast for
    # + days - Number of days to include in the forecast (e.g. 3, 5, 7)
    # + return - The multi-day weather forecast, or an error if the request fails
    remote function getWeatherForecast(string location, int days) returns WeatherForecast|error {
        if days < 1 || days > 14 {
            return error("days must be between 1 and 14");
        }
        return buildWeatherForecast(location, days);
    }

    # Get active weather alerts for a location, such as storm or wind warnings.
    #
    # + location - The city or place name to check for active weather alerts
    # + return - A list of active weather alerts, empty if there are none, or an error if the request fails
    remote function getWeatherAlerts(string location) returns WeatherAlert[]|error {
        return buildWeatherAlerts(location);
    }

    # Get a historical weather observation for a location on a specific past date.
    #
    # + location - The city or place name to get historical weather for
    # + date - The date to get historical weather for, in YYYY-MM-DD format
    # + return - The historical weather observation, or an error if the request fails
    remote function getHistoricalWeather(string location, string date) returns HistoricalWeather|error {
        return buildHistoricalWeather(location, date);
    }

    # Suggest clothing or activity recommendations based on a weather condition and temperature.
    #
    # + condition - The weather condition, e.g. Sunny, Rainy, Snowy, Cloudy
    # + temperatureCelsius - The temperature in degrees Celsius
    # + return - A short human-readable recommendation, or an error if the request fails
    remote function getRecommendation(string condition, decimal temperatureCelsius) returns string|error {
        return buildRecommendation(condition, temperatureCelsius);
    }
}
