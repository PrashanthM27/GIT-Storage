public class BatchSfdc implements Database.Batchable<Sobject>{
public Database.QueryLocator Start(Database.BatchableContext bc){
return Database.getQueryLocator('Select Id,Name from Account');
}
public void Execute(Database.BatchableContext bc,List<Sobject> scope){

}
public void Finish(Database.BatchableContext bc){

}
}