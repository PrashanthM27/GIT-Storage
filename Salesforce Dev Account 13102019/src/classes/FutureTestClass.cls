public class FutureTestClass {
@Future
    public static void FutMeth(String Name,String Email){
    Profile p=[Select Id from Profile where Name='Standard User'];
    UserRole r=[Select Id from UserRole where Name='CEO'];
    User u=new User(alias='Name',EMail='Email',ProfileId=p.Id,UserRoleId=r.Id);    
 insert u;
    }
}