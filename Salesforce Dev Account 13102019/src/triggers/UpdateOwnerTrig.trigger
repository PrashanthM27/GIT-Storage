trigger UpdateOwnerTrig on Account (after update) {
    Set<Id> ids=new Set<Id>();
    Map<Id,String> newId=new Map<Id,String>();
    Map<Id,String> oldId=new Map<Id,String>();
    for(Account a:Trigger.New){
        newId.put(a.Id,a.OwnerId);
        oldId.put(a.Id,Trigger.OldMap.get(a.Id).OwnerId);
        ids.add(a.Id);
    }
    List<Account> acList=[Select Id,Name,OwnerId,(Select Id,FirstName,LastName from Contacts)from Account where id in:ids];
    for(Account a:acList){
        for(Contact ct:a.Contacts){
            
        }
    }
}