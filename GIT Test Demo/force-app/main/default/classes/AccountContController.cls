public class AccountContController {
@AuraEnabled
    public static List<Contact> getAccount(List<Id> accountids){
        return [Select Id,Name,FirstName,LastName,email,Phone,AccountId from Contact where Id in:accountids];
        
    }
}