public class Ltng_AccountForm {
    @AuraEnabled
    public static void saveRecord(Account acObj){
        try{
            insert acObj;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Account> returnRecords(){
        return [Select Id,Name,Industry,AccountNumber,Phone FROM Account];
    }
}