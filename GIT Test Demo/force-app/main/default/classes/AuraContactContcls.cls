public class AuraContactContcls {
    @AuraEnabled
    public static List<Contact> conList(){
        List<Contact> con=[Select Id,FirstName,LastName from Contact];
        return con;
    }
}