public class WebserviceController{
public static void getData(){

Http ht=new Http();
HttpRequest request=new HttpRequest();
request.setEndpoint('http://api.openweathermap.org/data/2.5/group?');
request.setMethod('GET');
HttpResponse response=ht.send(request);
if(response.getStatusCode()==200){

}
}
}