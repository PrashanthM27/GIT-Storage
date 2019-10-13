@isTest
public class Test_AccountRecordSearch{
static testMethod void searchAcc(){

  Account a = new Account();
  a.Name = 'Test';
  insert a;
  
  List<Contact> cc= new List<Contact>();
  for(Integer i=0;i<20;i++){
  Contact ct = new Contact(LastName= a.Name+i);
  cc.add(ct);
  }
  
  List<Opportunity> optList = new List<Opportunity>();
  for(Integer i=0;i<20;i++){
  Opportunity opt = new Opportunity(Name=a.Name+i);
  
  }
  AccountRecordSearch  acRec = new AccountRecordSearch();
  acRec.Save();
  acRec.getTheRecords();
}
}