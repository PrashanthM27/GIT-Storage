public class LightningExmpClass {
@AuraEnabled
    public static List<Account> getTheMethod(){
        System.debug('Final Result:');
        return [Select Id,Name,Industry,Type from Account];
    }
    @AuraEnabled
    public static Account getTheAccount(String Id){
        System.debug('Called:');
        return [Select Id,Name,Industry from Account where id=:Id];
    }
}