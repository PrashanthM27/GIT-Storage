public with sharing class DeleteRecords{
public String st{set;get;}
public List<Account> ac{Set;get;}
public PageReference doDelete(){
ac=[Select Id from Account where id=:st];
delete ac;
PageReference pg=new PageReference('apex/deleteRecordCls');
pg.setRedirect(true);
return pg;
}
List<Account> acc=new List<Account>();
public List<Account> getRec(){
acc=[Select Id,Name,Industry from Account];
return acc;
}
}