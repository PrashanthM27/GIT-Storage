public class FutureCalls{
    @Future
    public static void FutMe(String Id,String Name){
     HttpRequest req=new HttpRequest();
     req.setEndpoint('http://cheenath.com/tutorial/sfdc/sample1/data.txt');
     req.setMethod('GET');
        
     Http ht=new Http();   
     HttpResponse res=ht.send(req);
        if(res.getStatusCode()==200){
            Account a=new Account();
            a.Description=res.getBody();
            update a;
        }else{
            System.debug('Failed Response:'+res);
        }
    }
}