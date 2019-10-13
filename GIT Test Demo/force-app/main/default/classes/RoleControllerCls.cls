public class RoleControllerCls {
    public String Selectedrole{Set;get;}
    public List<UserRole> usr{set;get;}
    public PageReference getRoleDetails(){
        usr=[Select DeveloperName,Name,Id,ParentRoleId from UserRole where Name LIKE:'%'+Selectedrole+'%'];
    return null;
    }
    public RoleControllerCls(ApexPages.StandardController controller){
        Selectedrole='';
    }
}