trigger AccountTrigger on Account (after update) 
{
    Set<Id> ids=new Set<Id>();
    for(Account a:Trigger.New){
        Account oldAcc=Trigger.OldMap.get(a.Id);
        if(a.Phone!=oldAcc.Phone){
            ids.add(a.Id);
        }
    }
    Map<Id,Account> accMap=new Map<Id,Account>([Select Id,Name,Phone,(Select Id,LastName,Phone from Contacts)from Account where id=:ids]);
    List<Contact> conts=new List<Contact>();
    for(Account a:Trigger.New){
    Account oldAcc=Trigger.OldMap.get(a.Id);
        if(a.Phone!=oldAcc.Phone){
            if(accMap.containsKey(a.Id)){
                Account ac3=accMap.get(a.Id);
                List<Contact> cont=ac3.contacts;
                for(Contact ct:cont){
                    ct.Phone=a.Phone;
                    conts.add(ct);
                }
            }
        }    
    }
    if(conts.size()>0){
        update conts;
    }
}