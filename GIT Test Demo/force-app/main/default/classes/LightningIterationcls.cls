public class LightningIterationcls {
@AuraEnabled
    public static List<Account> getResult(){
        List<Account> ac=[Select Id,Name,Industry,Phone from Account];
        return ac;
    }
}