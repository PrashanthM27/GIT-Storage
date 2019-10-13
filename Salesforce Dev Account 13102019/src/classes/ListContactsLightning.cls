public class ListContactsLightning {
@AuraEnabled
    public static List<Contact> getContacts(){
        return [Select Id,FirstName,LastName,Phone from Contact];
        
    }
}