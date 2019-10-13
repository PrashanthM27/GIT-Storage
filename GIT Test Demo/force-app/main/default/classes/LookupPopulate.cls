public class LookupPopulate{
public Account acc{set;get;}
public Id acctId{set;get;}
public String accNumber{set;get;}
public LookupPopulate(){
acc=new Account();
}
public PageReference Save(){
acc=[Select Id,AccountNumber,ParentId from Account where id=:acctId];
accNumber=acc.ParentId;
return null;
}
}