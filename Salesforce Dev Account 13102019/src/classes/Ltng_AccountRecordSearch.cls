public class Ltng_AccountRecordSearch {
    @AuraEnabled
    public static List<Account> accRecordSearch(String keyword){
        String key = keyword + '%';
        List<Account> searchRecordsList = new List<Account>();
        List<Account> acList = [Select Id,Name,Industry,Phone,Fax from Account where Name LIKE:keyword];
        for(Account ac:acList){
            searchRecordsList.add(ac);
            
        }
        return searchRecordsList;
    }
}