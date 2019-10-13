@isTest
public class ContactCountTest {
    static testmethod void countContact(){
    Account a=new Account();
    a.Name='Prathyush';
    a.NumberofLocations__c=3;
    insert a;
    List<Contact> con=[Select Id,LastName from Contact where AccountId=:a.Id];
        //System.assertEquals(a.NumberofLocations__c,con.size());
}
}