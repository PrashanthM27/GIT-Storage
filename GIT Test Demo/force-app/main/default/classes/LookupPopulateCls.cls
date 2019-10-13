public class LookupPopulateCls {
    public string accNum{set;get;}
    public Account acc{set;get;}
    public Id accId{set;get;}
    public LookupPopulateCls(){
        acc=new Account();
    }
    public PageReference Save(){
        acc=[Select AccountNumber,ParentId from Account where id=:accId limit 1];
         accId=acc.AccountNumber;
        return null;
    }
}