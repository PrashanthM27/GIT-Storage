public class AccountQuery_Controller {
    public List<Account> acList{set;get;}
    public AccountQuery_Controller(){
    acList = [Select Id,Name FROM Account];
}
}