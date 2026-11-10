import ballerina/time;

// Fixed set of conditions used to generate deterministic dummy weather data.
final string[] & readonly weatherConditions = ["Sunny", "Partly Cloudy", "Cloudy", "Rainy", "Thunderstorms", "Snowy", "Windy"];

// Derives a stable pseudo-random index in the range [0, bound) from a seed string.
isolated function deriveIndex(string seed, int bound) returns int {
    int total = 0;
    foreach int codePoint in seed.toCodePointInts() {
        total += codePoint;
    }
    return total % bound;
}

// Builds a dummy current weather reading for the given location.
isolated function buildCurrentWeather(string location) returns CurrentWeather {
    int conditionIndex = deriveIndex(location, weatherConditions.length());
    decimal baseTemperature = <decimal>(15 + deriveIndex(location, 18));
    time:Utc now = time:utcNow();
    string observedAt = time:utcToString(now);
    return {
        location: location,
        temperatureCelsius: baseTemperature,
        feelsLikeCelsius: baseTemperature - 1.5,
        condition: weatherConditions[conditionIndex],
        humidityPercent: 40 + deriveIndex(location, 50),
        windSpeedKmh: <decimal>(5 + deriveIndex(location, 25)),
        observedAt: observedAt
    };
}

// Builds a dummy multi-day forecast for the given location.
isolated function buildWeatherForecast(string location, int days) returns WeatherForecast {
    DailyForecast[] dailyForecasts = [];
    time:Utc now = time:utcNow();
    foreach int dayOffset in 0 ..< days {
        time:Utc futureDay = time:utcAddSeconds(now, <decimal>(dayOffset * 86400));
        time:Civil civilDay = time:utcToCivil(futureDay);
        string date = string `${civilDay.year}-${civilDay.month}-${civilDay.day}`;
        int conditionIndex = deriveIndex(location.concat(date), weatherConditions.length());
        decimal low = <decimal>(10 + deriveIndex(location.concat(date, "low"), 15));
        decimal high = low + <decimal>(3 + deriveIndex(location.concat(date, "high"), 10));
        dailyForecasts.push({
            date: date,
            highCelsius: high,
            lowCelsius: low,
            condition: weatherConditions[conditionIndex],
            chanceOfRainPercent: deriveIndex(location.concat(date, "rain"), 100)
        });
    }
    return {location: location, days: dailyForecasts};
}

// Builds a list of dummy weather alerts for the given location.
isolated function buildWeatherAlerts(string location) returns WeatherAlert[] {
    int alertCount = deriveIndex(location, 3);
    if alertCount == 0 {
        return [];
    }
    time:Utc now = time:utcNow();
    time:Utc expiry = time:utcAddSeconds(now, 21600);
    WeatherAlert alert = {
        severity: alertCount == 1 ? "Minor" : "Moderate",
        title: alertCount == 1 ? "Wind Advisory" : "Severe Thunderstorm Watch",
        description: string `Dummy alert generated for ${location}. Exercise normal caution.`,
        effectiveFrom: time:utcToString(now),
        effectiveUntil: time:utcToString(expiry)
    };
    return [alert];
}

// Builds a dummy historical weather observation for the given location and date.
isolated function buildHistoricalWeather(string location, string date) returns HistoricalWeather {
    int conditionIndex = deriveIndex(location.concat(date), weatherConditions.length());
    decimal low = <decimal>(8 + deriveIndex(location.concat(date, "low"), 12));
    decimal high = low + <decimal>(4 + deriveIndex(location.concat(date, "high"), 8));
    decimal average = (low + high) / 2;
    return {
        location: location,
        date: date,
        averageCelsius: average,
        highCelsius: high,
        lowCelsius: low,
        condition: weatherConditions[conditionIndex]
    };
}

// Builds a short recommendation string based on a weather condition and temperature.
isolated function buildRecommendation(string condition, decimal temperatureCelsius) returns string {
    string conditionAdvice;
    string lowerCondition = condition.toLowerAscii();
    if lowerCondition.includes("rain") || lowerCondition.includes("storm") {
        conditionAdvice = "carry an umbrella or wear a raincoat";
    } else if lowerCondition.includes("snow") {
        conditionAdvice = "wear warm layers and watch for slippery surfaces";
    } else if lowerCondition.includes("wind") {
        conditionAdvice = "wear a windbreaker and secure loose items";
    } else if lowerCondition.includes("cloud") {
        conditionAdvice = "a light jacket should be comfortable";
    } else {
        conditionAdvice = "sunglasses and light clothing should be comfortable";
    }

    string temperatureAdvice;
    if temperatureCelsius <= 5d {
        temperatureAdvice = "it is quite cold, so dress warmly";
    } else if temperatureCelsius <= 15d {
        temperatureAdvice = "it is cool, so a jacket is recommended";
    } else if temperatureCelsius <= 25d {
        temperatureAdvice = "the temperature is mild";
    } else {
        temperatureAdvice = "it is warm, so stay hydrated";
    }

    return string `Based on ${condition} conditions and ${temperatureCelsius}°C, ${temperatureAdvice}; ${conditionAdvice}.`;
}
