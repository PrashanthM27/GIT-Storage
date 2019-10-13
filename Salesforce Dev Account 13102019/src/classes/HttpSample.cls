public class HttpSample{
public String getCalloutResponse(String url){
Http ht=new Http();
HttpRequest req=new HttpRequest();
req.setEndpoint(url);
req.setMethod('GET');
HttpResponse res=new HttpResponse();
return res.getBody();
}
}