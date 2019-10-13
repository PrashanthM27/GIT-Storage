@RestResource(urlmapping='/v1/getContacts/*')
global with sharing class GetRestPostMan{
@HttpGet
global static list<Account> fetchAccount(){
RestRequest req=RestContext.request;
RestResponse resp=RestContext.response;
//Id accId=req.requestURI.subString(req.requestURI.LastIndexof('/')+1);
list<Account> cont=[Select Id,Name,Industry from Account limit 1];
return cont;
}
}