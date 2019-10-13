public class CurrentUserFinding{
public void findCurrentUser(){
Set<Id> setids=new Set<Id>();
Id currentUserId=UserInfo.getUserId();
List<Account> acc=[Select Id from Account LIMIT 3];
for(Account userids:acc){
setids.add(userids.Id);
}
List<UserRecordAccess> userrec=[Select RecordId,HASREADACCESS,HASEDITACCESS,HASDELETEACCESS,HASTRANSFERACCESS FROM UserRecordAccess 
where userid=:currentUserId and recordId in:setids];
System.debug('Current User Access'+userrec);
}
}