public class GetContact {
@AuraEnabled
    public static List<Contact> getselOptions(Id recId){
        return [Select Id,FirstName,LastName,Email from Contact where AccountId=:recId];
    }
}