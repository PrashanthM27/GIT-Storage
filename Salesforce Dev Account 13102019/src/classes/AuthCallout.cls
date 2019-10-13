public class AuthCallout {
    public void basicAuthCallout(){
        HttpRequest req=new HttpRequest();
        req.setEndPoint('http://www.google.com');
        req.setMethod('GET');
        String username='Hello';
        String password='fnfnfn';
       Blob lb=Blob.valueOf(username+' '+password);
       String authorizationHeader='BASIC'+EncodingUtil.base64Encode(lb);
        req.setHeader('Authorization',authorizationHeader);
        Http ht=new Http();  
        HttpResponse res=ht.send(req);
    }
}