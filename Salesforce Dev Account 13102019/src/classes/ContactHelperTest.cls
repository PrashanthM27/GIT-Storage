@isTest
private class ContactHelperTest{
static testmethod void Save(){
Account a=new Account();
a.Name='TCS';
a.BillingCity='Delhi';
a.BillingState='UP';
a.BillingCountry='India';
insert a;

Contact cont=new Contact();
cont.AccountId=a.Id;
cont.FirstName='Prashanth';
cont.LastName='Chowdary';
insert cont;

Test.StartTest();
ContactHelper.setDefaultValues(new List<Contact>{cont});
Test.StopTest();
}
}