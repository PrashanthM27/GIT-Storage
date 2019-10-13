public class AccountCont{
public List<Account> ac{set;get;}
public void Save(){
ac=[Select Id,Name,(Select Id,FirstName,LastName from Contacts) from Account];
}
}