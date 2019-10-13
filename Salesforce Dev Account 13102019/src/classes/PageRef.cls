public class PageRef{
public PageReference Save(){
Account ac=[Select Id,Name from Account WHERE Name='Prashanth' LIMIT 1];
PageReference pf=new PageReference('/'+ac.Id);
pf.setRedirect(true);
return pf;
}
}