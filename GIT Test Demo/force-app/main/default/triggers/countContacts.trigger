trigger countContacts on Contact (after insert,after update,after delete,after undelete) {
Set<Id> ids= new Set<Id>();
if(Trigger.isInsert){
for(Contact c1:Trigger.New){
ids.add(c1.AccountId);
}
}
else if(Trigger.isDelete){
for(Contact c2:Trigger.Old){
ids.add(c2.AccountId);
}
}
else if(Trigger.isUndelete){
for(Contact c3:Trigger.New){
ids.add(c3.AccountId);
}
}
List<Account> a3=new List<Account>();
List<Account> acc=[Select Id,Name,CountofContacts__c,(Select Id,FirstName,LastName from Contacts)from Account where id=:ids];
for(Account a:acc){
a.CountofContacts__c=a.Contacts.size();
a3.add(a);
}
update a3;

}