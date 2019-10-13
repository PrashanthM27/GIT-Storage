public class RoleHierarchyController {
    public List<UserRole> childRoles{set;get;}
    public UserRole parentrole{set;get;}
    public UserRole currentRole{set;get;}
    public String RoleIdStr{set;get;}
    public String ParentRoleStr{set;get;}
    public PageReference pg(){
        try{
        parentrole=[Select Id,Name,ParentRoleId from UserRole where id=:ParentRoleStr];
        }catch(Exception e){
        currentRole=[Select Id,Name,ParentRoleId from UserRole where id=:RoleIdStr];
        childRoles=[Select Id,Name,ParentRoleId from UserRole where ParentRoleid=:RoleIdStr];
        }
        return null;
    }
    public RoleHierarchyController(ApexPages.StandardController controller){
        RoleIdStr=ApexPages.CurrentPage().getParameters().get('roleId');
        ParentRoleStr=ApexPages.currentPage().getParameters().get('parentId');
        
    }
    }