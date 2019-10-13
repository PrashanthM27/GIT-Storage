trigger OneContactForAccount on Contact (before insert) {
Set<Id> ids=new Set<Id>();
for(Contact c:Trigger.New){
ids.add(c.AccountId);
}
List<Contact> c3=new List<Contact>();
List<Account> ac=[Select Id,Name,(Select Id,FirstName,LastName from Contacts)from Account where id=:ids];
for(Account a2:ac){
for(Contact cc:a2.Contacts){
c3.add(cc);
}
}
for(Contact ct:Trigger.New){
if(c3.size()>0){
ct.addError('Cannot create more than one Contact for a Account');
}
}
}