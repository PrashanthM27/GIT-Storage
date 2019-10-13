@isTest
public class AccountTriggerTest {
    static testMethod void AccTest(){
        Account a=new Account(Name='Bharath',Industry='Education',Phone='3224233');
        insert a;
        Contact c1=new Contact(FirstName='Prashanth',LastName='Murukonda',Phone='4322312',AccountId=a.Id);
        insert c1;
        Contact c2=new Contact(FirstName='Jay',LastName='Murukonda',Phone='2432532421',AccountId=a.Id);
        insert c2;
        
        a.Name='Arun';
        a.Phone='23423432';
        update a;
        System.assertEquals(a.Phone, c1.Phone);
    }
}