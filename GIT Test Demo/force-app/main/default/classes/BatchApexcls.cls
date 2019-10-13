global class BatchApexcls implements Database.Batchable<Sobject>{
global Database.QueryLocator Start(Database.BatchableContext bc){
return Database.getQueryLocator('Select Id,Name from Account');
}
global void Execute(Database.BatchableContext bc,List<Account> scope){
for(Account a:scope)
{
a.Name=a.Name+'Updated my batch job';
}
update scope;
}
global void Finish(Database.BatchableContext bc){

}
}