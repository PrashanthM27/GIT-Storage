public class DuplicateRecords{
public void Save(){
Account a=new Account(Name='Prashanth');
insert a;
List<Id> ids=new List<Id>();
ids.add(a.Id);
if(Datacloud.FindDuplicatesByIds.findDuplicatesByIds(ids).size()>0){
System.debug('Duplicates Found');
}else{
System.debug('No Duplicates');
}
}
}