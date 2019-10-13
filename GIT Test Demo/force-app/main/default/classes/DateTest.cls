@isTest
public class DateTest{
static testmethod void Data(){
Account a=new Account(Name='Prathyu Press');
insert a;
Test.setCreatedDate(a.Id,DateTime.newInstance(2018,09,03));
Test.StartTest();
Account aa=[Select Id,Name,CreatedDate from Account where Name='Prathyu Press'];
System.assertEquals(aa.CreatedDate,DateTime.newInstance(2018,09,03));
Test.StopTest();
}
}