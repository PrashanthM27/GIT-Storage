public class Ltng_ReuseLookupController {
    @AuraEnabled
    public static List<AccountListWrapper> fectchAccountWrapper(){
    List<AccountListWrapper> wrapList = new List<AccountListWrapper>();
        for(Account acc:[Select Id,Name,Type,Phone from Account LIMIT 1000]){
            wrapList.add(new AccountListWrapper(false,acc));
        }
        return wrapList;
    }
    public class AccountListWrapper{
        public boolean isChecked{set;get;}
        public Account objAccount{set;get;}
        public AccountListWrapper(boolean isChecked,Account objAccount){
            this.isChecked = isChecked;
            this.objAccount = objAccount;
        }
    }
}