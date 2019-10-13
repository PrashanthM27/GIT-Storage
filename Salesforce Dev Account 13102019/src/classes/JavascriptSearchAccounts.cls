public class JavascriptSearchAccounts{
public String search{set;get;}
public List<Account> ac{set;get;}
public JavascriptSearchAccounts(){
ac=new List<Account>();
} 
public PageReference SeachAccounts(){
String str='%' +search+ '%';
ac=[Select Id,Name,Type,Industry from Account where name like:str];
return null;
}
public PageReference clearResults(){
ac.clear();
return null;
}
public boolean getResults(){
return(ac.size()>0);
}
}