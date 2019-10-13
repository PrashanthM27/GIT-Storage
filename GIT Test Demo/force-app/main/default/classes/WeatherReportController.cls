public with sharing class WeatherReportController {

public WeatherReport weatherData { get; set; }

public WeatherReportController() {
this.weatherData = WeatherReportHTTPRequest.getWeatherReport('London');
}
}