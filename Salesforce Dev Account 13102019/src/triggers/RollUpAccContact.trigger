trigger RollUpAccContact on Contact (after insert,after delete,after undelete) {
Set<Id> contIds =new Set<Id>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Contact cont :Trigger.New){
            contIds.add(cont.AccountId);
        }
    }
    if(Trigger.isAfter || Trigger.isDelete){
        for(Contact cont1:Trigger.Old) {
            contIds.add(cont1.AccountId);
        }
    }
    if(Trigger.isAfter || Trigger.isUndelete){
        for(Contact cont2:Trigger.Old){
            contIds.add(cont2.AccountId);
        }
    }
     List<Account> accList = [Select Id,Name,NumberofContacts__c,(Select Id FROM Contacts) FROM Account where Id=:contIds];
    for(Account acc:accList){
        acc.NumberofContacts__c = acc.Contacts.size();
        
    }
}