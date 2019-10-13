public class CheckboxUsingJavascript1{
public List<CheckboxWrapAccount> wrapAcc{set;get;}
public CheckboxUsingJavascript1(){
if(wrapAcc==null){
  wrapAcc=new List<CheckboxWrapAccount>();
  for(Account aa:[Select Id,Name,Industry from Account]){
  wrapAcc.add(new CheckboxWrapAccount(aa));
  }
}
}


public class CheckboxWrapAccount{
public Account ac{set;get;}
public Boolean selected{set;get;}
public CheckboxWrapAccount(Account a){
ac=a;
selected=false;
}
}
}