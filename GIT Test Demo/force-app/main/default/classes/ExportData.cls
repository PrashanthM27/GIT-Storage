public class ExportData{
public List<Account> ac{set;get;}
public ExportData(){
ac=new List<Account>();
}
public void getAccountDetails(){
ac=[Select Id,Name,Industry from Account];
}
}