global class BatchQuery implements Database.Batchable<Sobject> {
    global database.QueryLocator Start(Database.BatchableContext bc){
        String queryList='Select Id,Name from Account';
        return Database.getQueryLocator(queryList);
    }
    global void Execute(Database.BatchableContext bc,List<Account> scope){
        
    }
    global void Finish(Database.BatchableContext bc){
        
    }
}