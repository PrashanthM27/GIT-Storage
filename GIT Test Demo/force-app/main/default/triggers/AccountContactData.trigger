trigger AccountContactData on Contact (before insert) {
   Set<Id> ids=new Set<Id>();
    for(Contact c:Trigger.New){
        ids.add(c.AccountId);
        System.debug('======>>>Result Ids:'+ids);
    }
    List<Account> acc=[Select Id,Name,(Select Id,FirstName,LastName from Contacts) from Account where id=:ids];
    System.debug('=====>Result:'+acc);
}