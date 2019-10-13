public class ZippopotusInt{
public static HttpResponse getData(){
Http ht=new Http();
HttpRequest req=new HttpRequest();
req.setEndpoint('http://api.zippopotam.us/us/90210');
req.setMethod('GET');
HttpResponse res=ht.send(req);
if(res.getStatusCode()==200){
Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
}
return res;
}
}