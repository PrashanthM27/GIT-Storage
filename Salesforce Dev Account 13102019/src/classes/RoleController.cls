public class RoleController{
public String rId{set;get;}
public String pId{set;get;}
public UserRole cRole{set;get;}
public UserRole parentRoleSt{set;get;}
public List<UserRole> childs{set;get;}
public PageReference getRoleDetails(){
try{
parentRoleSt=[Select Id,Name,ParentRoleId from UserRole where ParentRoleId=:pId];
}catch(Exception e){
childs=[Select Id,Name,ParentRoleId from UserRole WHERE id=:rId];
cRole=[Select Id,Name,ParentRoleId from UserRole where Id=:rId];
}
return null;
}
public RoleController(ApexPages.StandardController controller){
rId=ApexPages.CurrentPage().getParameters().get('roleId');
pId=ApexPages.CurrentPage().getParameters().get('parentId');
}
}