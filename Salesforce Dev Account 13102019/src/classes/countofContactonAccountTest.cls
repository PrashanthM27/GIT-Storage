@isTest
public class countofContactonAccountTest{
static testMethod void Save(){
Account a=new Account();
a.Name='Exam';
insert a;
Contact c=new Contact();
c.AccountId=a.Id;
c.FirstName='Exam';
c.LastName='Pariksha';
insert c;
List<Account> ac=[Select Id,Name,NumberofLocations__c,(Select Id,FirstName,LastName from Contacts)from Account where id=:c.Id];
}
}