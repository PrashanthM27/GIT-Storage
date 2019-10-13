public class BatchStateful2 implements Database.Batchable<Sobject>,Database.Stateful {
    public Database.QueryLocator Start(Database.BatchableContext BC){
        String Query='Select Id,Name from Account';
        return Database.getQueryLocator(Query);
    }
    public void Execute(Database.BatchableContext BC,List<Account> scope){
        System.debug('Scope Result:'+scope);
        for(Account a:scope){
            Account aa=(Account)a;
            System.debug('Account Result:'+aa);
        }
    }
    public void Finish(Database.BatchableContext BC){
        
    }
}