public class ActionFunction{
String uname{set;get;}
public String getUserName(){
return uname;
}
public PageReference sayHello(){
uname=UserInfo.getName();
return null;
}
public void setState(String n){
state=n;
}
public String getState(){
return state;
}
public PageReference methodone(){
return null;
}
private String state='no';
}