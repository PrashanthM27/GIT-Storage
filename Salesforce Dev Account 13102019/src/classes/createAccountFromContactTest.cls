@isTest
public class createAccountFromContactTest{
static testMethod void createAccount(){
String firstname='Savitri';
String lastname='Mahanati';
String email='prashanthpmsfdc@gmail.com';
Contact c=new Contact(FirstName=firstname,LastName=lastname,Email=email);
insert c;
c=[Select Id,AccountId,FirstName,LastName from Contact where id=:c.Id];
Account a=[Select Id,Name,Industry from Account where id=:c.AccountId];
System.assertEquals(FirstName+''+LastName,a.Name);
}
}