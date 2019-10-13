public class Ltng_AccountRecordCheck {
@AuraEnabled
    public static List<Account> accList(){
        return [Select Id,Name,Industry,Phone,VIP_Check__c from Account where Id!=NULL];
        
    }
}