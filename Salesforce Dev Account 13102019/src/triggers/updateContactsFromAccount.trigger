trigger updateContactsFromAccount on Account (after update) {
  Contact[] updatedContacts = new Contact[0];
  Account[] changedAccounts = new Account[0];
  for(account a:Trigger.new) {
    if(a.phone != trigger.oldmap.get(a.id).phone ||
       a.fax != trigger.oldmap.get(a.id).fax ||
       a.billingstreet != trigger.oldmap.get(a.id).billingstreet || 
       a.billingcity != trigger.oldmap.get(a.id).billingcity ||
       a.billingstate != trigger.oldmap.get(a.id).billingstate || 
       a.billingpostalcode != trigger.oldmap.get(a.id).billingpostalcode ||
       a.billingcountry != trigger.oldmap.get(a.id).billingcountry) {
      changedAccounts.add(a);
    }
  }
    for(Contact c:[Select Id,FirstName,LastName,Phone,AccountId from Contact where AccountId in:Trigger.New]){
        Account a=Trigger.NewMap.get(c.AccountId);
        if(c.Phone==Trigger.OldMap.get(c.AccountId).Phone){
            c.Phone=a.Phone;    
          updatedContacts.add(c);     
        }
    }
    update updatedContacts;
}