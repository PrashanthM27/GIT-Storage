public class CurrentPage{
public Account ac{set;get;}
public PageReference Save(){
ac=[Select Id,Name from Account where id=:ApexPages.CurrentPage().getParameters().get('Id')];
return null;
}
}