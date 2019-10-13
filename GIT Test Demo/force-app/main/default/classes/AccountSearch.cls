public class AccountSearch {
   public String aName{set;get;}
   public String aIndustry{set;get;}
   public String aPhone{set;get;}
   public List<Account> ac{set;get;}
   public Account accSearch{set;get;}
   public AccountSearch(){
   accSearch=new Account();
   }
   public void Search(){
   ac=[Select Id,Name,Industry,Phone from Account where Name=:aName OR Industry=:aIndustry OR Phone=:aPhone];
  
   }
}