public class AccountRecordDisplay {
    public Id ac{set;get;}
    public Account acct{set;get;}
    public AccountRecordDisplay(){
        ac=ApexPages.currentPage().getParameters().get('Id');
          acct=[Select Id,Name,Phone from Account where id=:ac];  
            
            }
}