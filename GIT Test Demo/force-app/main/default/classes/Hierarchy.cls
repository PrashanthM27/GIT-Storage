public class Hierarchy{
public Account ac{set;get;}
public List<Contact> cont{set;get;}
public Hierarchy(Account a,List<Contact> con){
ac=a;
cont=con;
}
//End wrapper class
public List<Hierarchy> hr{set;get;}
public List<Hierarchy> getContactsRecords()
{
hr=new List<Hierarchy>();
List<Account> act=[Select id,Name from Account];
for(Integer i=0;i<act.size();i++){
cont=[Select Id,FirstName,LastName,(Select Id,caseNumber,Subject from Cases) from Contact where AccountId=:act[i].Id];
hr.add(new Hierarchy(act[i],cont));
}
    return hr;
}
}