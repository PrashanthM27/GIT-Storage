public with sharing class DeleteTestingNew {
public String rId{get;set;}
Account delDlt = new Account();
public PageReference doDelete() {
delDlt=[select Id from Account where id =:rId];
delete delDlt;
pagereference ref=new pagereference('/apex/newdelete');
ref.setredirect(true);
return ref;
}
List<Account> lstdlt = new List<Account>();
public List<Account> getRecords() {
lstdlt =[select id,name,industry,phone from Account];
return lstdlt;
}
}