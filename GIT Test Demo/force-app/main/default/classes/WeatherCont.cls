global with sharing class WeatherCont{
    public String city {get;set;}
    public String temp {get;set;}
    public String pressure {get;set;}
    public String humidity {get;set;}
    public String temp_min {get;set;}
    public String temp_max {get;set;}
    public List<weatherData> listValues {get;set;}
    public String JsonData;
    
    public List<weatherData> getWeatherData(){
        String requestEndpoint = 'https://api.openweathermap.org/data/2.5/weather?q='+city+'&appid=bd5e378503939ddaee76f12ad7a97608';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestEndpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            List<weatherData> items = new  List<weatherData>();
            String JsonDataRes = response.getBody();
            reCls reData = new reCls();
            list<WeatherData> itemsData = reData.items;
            reCls resItem = (reCls)JSON.deserialize(JsonDataRes, reCls.class);
            List<weatherData> jsnData = resItem.items;
            List<weatherData> listValues = new List<weatherData>();
            for(weatherData wIterator:jsnData){
                temp = wIterator.temp;
                pressure = wIterator.pressure;
                humidity = wIterator.humidity;
                temp_min = wIterator.temp_min;
                temp_max = wIterator.temp_max;
                listValues.add(wIterator);
            }
            System.debug('==lstValue==='+jsnData);
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There was an error retrieving the weather information.');
            ApexPages.addMessage(myMsg);
        }
        return listValues;
    }
    global class reCls {
        List<weatherData> items;
    }
    
    global class weatherData {
        public String temp {get;set;}
        public String pressure {get;set;}
        public String humidity {get;set;}
        public String temp_min {get;set;}
        public String temp_max {get;set;}
    }
}