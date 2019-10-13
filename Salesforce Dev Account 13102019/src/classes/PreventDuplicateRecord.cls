public class PreventDuplicateRecord{
public void preventDupRecord()
{
Database.DMLOptions opt=new Database.DMLOptions();
opt.DuplicateRuleHeader.allowSave=true;
opt.DuplicateRuleHeader.runAsCurrentUser=true;
Account ac=new Account(Name='Prashanth');
Database.SaveResult result=Database.insert(ac,opt);
if(result.isSuccess()){
System.debug('Record has been Successfully inserted');
}else{
System.debug('Sorry!Duplicate Name found so cant be inserted');
}
}
}