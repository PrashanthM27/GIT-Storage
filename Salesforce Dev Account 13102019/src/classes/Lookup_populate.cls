public class Lookup_populate{

public String AccNo{get;set;}
public Id AccountId;
public Account cont {get;set;} 

public Lookup_populate(){
   cont =new Account ();
}

   public pagereference AccountPopulated(){
  cont=[select AccountNumber,ParentId  from Account where id=:cont.ParentId limit 1];
  AccNo= cont.AccountNumber;
  return null;
  }
 }