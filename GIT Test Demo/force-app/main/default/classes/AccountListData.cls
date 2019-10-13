public class AccountListData {
@AuraEnabled
    public static List<Account> getAccounts(){
        List<Account> ac=[Select Id,Name,Industry from Account];
        return ac;
    }
}