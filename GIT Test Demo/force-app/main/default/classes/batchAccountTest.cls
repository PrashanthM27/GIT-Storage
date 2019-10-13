@isTest
private class batchAccountTest{
static testMethod void accountM(){
Profile p=[select id from profile where name='system Administrator'];
User u=new User(alias='u',email='prashanth.murukondaa23@gmail.com',emailencodingkey='UTF-8', lastname='lstname',
                timezonesidkey='America/Los_Angeles',
                languagelocalekey='en_US',
                localesidkey='en_US',profileid=p.Id,username='linga.ramin@gmail.com');
 insert u;
Account a=new Account(name='testName',OwnerId=u.Id);
insert a;
Test.StartTest();
batchAccount ac=new batchAccount();
Id dd=Database.executeBatch(ac);
Test.StopTest();
}
}