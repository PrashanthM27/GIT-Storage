public class WeatherReportData{
public String city { get; set; }
public String weather { get; set; }
public String description { get; set; }
public Integer currentTemperature { get; set; }
public Integer maxTemperature { get; set; }
public Integer minTemperature { get; set; }
public Integer zipCode{set;get;}
    
    public WeatherReportData(){
        
    }
    public void getReport(String jsonData){        
     Http ht=new Http();
        String endPoint='http://api.openweathermap.org/data/2.5/weather?q=/'+city;        
     HttpRequest req=new HttpRequest();
     HttpResponse res=ht.send(req);
    if (res.getStatusCode() == 200) {
   Map<String,Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonData);
this.city = responseMap.get('name') != null ? (String)responseMap.get('name') : '';
List<Object> descriptionList = (List<Object>)responseMap.get('weather');
Map<String, Object> descriptionMap = (Map<String, Object>)descriptionList[0];
this.weather = descriptionMap.get('main') != null ? (String)descriptionMap.get('main') : '';
this.description = descriptionMap.get('description') != null ? (String)descriptionMap.get('description') : '';

// Parse current, maximum, and minimum temperature
Map<String,Object> temperatureDataMap = (Map<String, Object>)responseMap.get('main');
this.currentTemperature = (Integer)(1.8*((Double)temperatureDataMap.get('temp')-273)+32);
this.maxTemperature = (Integer)(1.8*((Double)temperatureDataMap.get('temp_max')-273)+32);
this.minTemperature = (Integer)(1.8*((Double)temperatureDataMap.get('temp_min')-273)+32);
}        
    }
}