trigger RollUpSumm on Contact (after insert,after update,after delete,after undelete) {
    Set<Id> ids=new Set<Id>();
    if(Trigger.isInsert||Trigger.isUndelete)
    for(Contact c:Trigger.New){
        ids.add(c.Id);
    }
    if(Trigger.isDelete||Trigger.isUpdate){
        for(Contact c2:Trigger.Old){
            ids.add(c2.Id);
            }
    }
    List<Account> acList=new List<Account>();
    for(Account a:[Select Id,Name,(Select Id,FirstName,LastName from Contacts)from Account where id=:ids]){
        a.NumberofContacts__c=a.Contacts.size();
        acList.add(a);
    }
    if(acList.size()>0){
        update acList;
    }
   
}