public class LightningContactCls {
@AuraEnabled
    public List<Contact> getContacts(){
        List<Contact> con=[Select FirstName,LastName,Phone from Contact];
        return con;
    }
}