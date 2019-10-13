@isTest
public class ContactsTestDataFactory{
    public static List<Contact> generateRandomContacts(Integer conCount,String lName){
        List<Contact>  contact=new List<Contact>();
        for(Integer i=0;i<conCount;i++){
            Contact con=new Contact(LastName=lName,FirstName='Raj'+i);
         contact.add(con);
        }
        insert contact;
        return contact;
    }
}