@isTest
public with sharing class Test_FCST_RoleHierarchySetUp {
    public static testMethod void UnitTest() {
        user loginUser = FCST_Util.createUser();        
        system.runAs(loginUser){ 
            User u = [select Id,UserRoleId from User where id=: userInfo.getUserId()];
           map<id,user> mapuser= new map<id,user>();
           mapuser.put(u.id,u);
            system.debug(mapuser);
            UserRole ur = [select id,name,ParentRoleId from UserRole where id=:u.UserRoleId];
            map<id,userRole> mapUserRole= new map<id,userRole>();
            mapUserRole.put(ur.id,ur);
            Test.StartTest();
            	FCST_RoleHierarchySetUp.getUsersByRoleId(mapUserRole,mapuser);
            	FCST_RoleHierarchySetUp.getRolesByRoleId(mapUserRole);
                FCST_RoleHierarchySetUp.getHierarchycalUserList();
                FCST_RoleHierarchySetUp.getRoleHierarchy(u.UserRoleId);
            Test.StopTest();
        }
    }
}