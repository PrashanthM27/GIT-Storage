public with sharing class WeatherReportHTTPRequest {
public WeatherReportHTTPRequest(){

}
    public static WeatherReport getWeatherReport(String City) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('http://api.openweathermap.org/data/2.5/weather' + City);
 
        try {
            Http http = new Http();
            HTTPResponse res = http.send(req);
 
            System.debug(LoggingLevel.INFO, 'STATUS:' + res.getStatus());
            System.debug(LoggingLevel.INFO, 'STATUS_CODE:' + res.getStatusCode());
            System.debug(LoggingLevel.INFO, 'BODY:' + res.getBody());
 
           WeatherReport result = new WeatherReport(res.getBody());
           return result;
        } catch(System.CalloutException e) {
            System.debug(LoggingLevel.INFO, 'ERROR:' + e.getMessage());
            return null;
            }
            }
            }