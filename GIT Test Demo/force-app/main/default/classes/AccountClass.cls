public class AccountClass{
public List<Account> ac{set;get;}
@testVisible
private void accTestMethod(){
ac=[Select Id,Name from Account];
}
}