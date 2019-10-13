public class ListAccounts {
@AuraEnabled
    public static List<Contact> getAccounts(){       
        return [Select Id,FirstName,LastName,Phone from Contact];
    }
}