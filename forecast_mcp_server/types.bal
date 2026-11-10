// Represents current weather conditions for a location.
type CurrentWeather record {|
    string location;
    decimal temperatureCelsius;
    decimal feelsLikeCelsius;
    string condition;
    int humidityPercent;
    decimal windSpeedKmh;
    string observedAt;
|};

// Represents the forecast for a single day.
type DailyForecast record {|
    string date;
    decimal highCelsius;
    decimal lowCelsius;
    string condition;
    int chanceOfRainPercent;
|};

// Represents a multi-day forecast for a location.
type WeatherForecast record {|
    string location;
    DailyForecast[] days;
|};

// Represents an active weather alert.
type WeatherAlert record {|
    string severity;
    string title;
    string description;
    string effectiveFrom;
    string effectiveUntil;
|};

// Represents a historical weather observation for a past date.
type HistoricalWeather record {|
    string location;
    string date;
    decimal averageCelsius;
    decimal highCelsius;
    decimal lowCelsius;
    string condition;
|};
