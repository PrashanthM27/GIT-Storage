public class Ltng_CustomSortingController {
    public List<AccountWrapper> acWrapper;
    public static AccountWrapper getAccountRecords(Integer initialRows){
        AccountWrapper accountWrapper= new AccountWrapper();
        try{
            accountWrapper.accountsList = [SELECT ID,Name,Rating,AccountSource FROM Account ORDER BY Name ASC LIMIT :initialRows OFFSET 0];
            accountWrapper.totalRecords = [SELECT COUNT() FROM Account];
            accountWrapper.message = 'Account records are loaded';
            accountWrapper.success = true;
        }
        catch(Exception e){
            accountWrapper.message = e.getMessage();
            accountWrapper.success = false;
        }
        return accountWrapper;
    }
    
    public static List<Account> loadAccountRecords(Integer rowLimit,Integer rowOffSet){
        return [Select Id,Name,Industry,AccountSource from Account ORDER BY Name LIMIT:rowLimit OFFSET:rowOffSet];
    }
    
    
    public class AccountWrapper{
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<Account> accountsList = new List<Account>();
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean success;
    }      
}