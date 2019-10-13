public class contrlcls {
    public contrlcls(){
        User u=[Select Id,Name,Phone from User where Id=:UserInfo.getUserId()];
        UserName=u.Name;
        UserPhone=u.Phone;
        Url=System.Url.getSalesforceBaseUrl().toExternalForm();
    }
    public String UserName{Set;get;}
    public String UserPhone{set;get;}
    public String Url{set;get;}
}