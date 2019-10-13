public class BatchApexStateful implements Database.Batchable<Sobject>,Database.Stateful{
    Map<Id,String> str=new Map<Id,String>();
    Map<Id,Sobject> obj=new Map<Id,Sobject>();
    public Database.QueryLocator Start(Database.BatchableContext bc){
        String Query='Select Id,Name,owner.Id from Account';
        System.debug('Query Result:'+Query);
        return Database.getQueryLocator(Query);
    }
    public void Execute(Database.BatchableContext bc,List<Account> scope){
            List<Account> ac2=new List<Account>();
             System.debug('Scope Result:'+scope.size());  
        for(Account a:scope){
            a.Name=a.Name+'Prathyu';
            
            update scope;
        }
        
    }
    public void Finish(Database.BatchableContext bc){
    AsyncApexJob jb=[Select Id,NumberofErrors,ApexclassId,TotalJobItems,JobItemsProcessed,CreatedBy.Email from AsyncApexJob where Id=:bc.getJobId()];
    System.debug('Final Result:'+jb);
       BatchApexStateful f=new BatchApexStateful(); 
    Id Job=Database.executeBatch(f);
        
    }
}