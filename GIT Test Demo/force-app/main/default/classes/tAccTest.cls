@isTest
public class tAccTest{
static testMethod void Save(){
Account a=new Account();
a.Name='MPC';
a.Industry='Education';
a.NumberofLocations__c=4;
insert a;
List<Contact> cont=[Select Id from Contact where AccountId=:a.Id];
System.assertEquals(a.NumberofLocations__c,cont.size());
}
}