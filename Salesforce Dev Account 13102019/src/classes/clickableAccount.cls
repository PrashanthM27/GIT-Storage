public class clickableAccount{
public List<Account> ac{set;get;}
public clickableAccount(){
ac=[Select Id,Name,Industry,Phone from Account];
}
public PageReference click(){
PageReference p=new PageReference('/apex/AccountId');
ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'You clicked on Name'));
return null;
}
}