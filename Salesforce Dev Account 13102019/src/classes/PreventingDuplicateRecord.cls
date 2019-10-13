public class PreventingDuplicateRecord{
public void PreventDupRecord(){
Database.DMLOptions options=new Database.DMLOptions();
options.duplicateRuleHeader.AllowSave=false;
options.duplicateRuleHeader.runAsCurrentUser=true;
Account a=new Account(Name='prashanth');
Database.SaveResult res=Database.insert(a,options);
if(res.isSuccess()){
System.debug('Record has been successfully inserted');
}else{
if(!res.isSuccess()){
for(Database.Error err:res.getErrors()){
DataCloud.DuplicateResult result=((Database.DuplicateError)err).getDuplicateResult();
System.debug('Duplicate Records has been detected  by:'+result.getErrorMessage());

}}
}
}
}