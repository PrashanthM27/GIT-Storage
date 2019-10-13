public class JavaScriptActionFunction{
public Account ac{set;get;}
PageReference pf{set;get;}
public JavaScriptActionFunction(){
ac=new Account();
}
public PageReference Save(){
if(ac.Name!=null){
insert ac;
}else
{
ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'Hello {!User.Name}! please enter Name');
ApexPages.addMessage(msg);
}
if(ac.id!=null){
pf=new PageReference('/'+ac.id);
pf.setRedirect(true);
}
return pf;
}
}