public class AccountRecordsD {
    public List<Account> ac{set;get;}
    public AccountRecordsD(){
        ac=new List<Account>();
    }
    public void Save(){
     ac=[Select Id,Name from Account];   
    }
}