public class Ltng_AccountSortController {
@AuraEnabled
    public static List<Account> accountSort(){
        return [Select Id,Name,Industry,Phone FROM Account WHERE Id!= NULL];
    }
}