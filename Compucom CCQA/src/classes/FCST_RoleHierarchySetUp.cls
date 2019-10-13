public with sharing class FCST_RoleHierarchySetUp {
    public static set<Id> getHierarchycalUserList(){
      User cUser;
      if (Schema.sObjectType.User.fields.Id.isAccessible() && Schema.sObjectType.User.fields.UserRoleId.isAccessible()){ 
          cUser = [select Id,UserRoleId from User where Id =: userinfo.getUserId() and isActive = true];
        }  
        Set<ID> finalUserIdSet= new set<Id>();  
        if(cUser.UserRoleId <> null){
            Set<ID> setUserRole = new Set<Id>();
            setUserRole.add(cUser.UserRoleId);   
            finalUserIdSet.addAll(getAllSubRoleIds(setUserRole));  
        }
        set<Id> setFUser = new set<Id>();
         if (Schema.sObjectType.User.fields.Id.isAccessible() && Schema.sObjectType.User.fields.Name.isAccessible()){
          for(User u : [select Id,Name from User where (UserRoleId IN: finalUserIdSet or Id =: userinfo.getUserId())  and isActive = true]){
              setFUser.add(u.Id);
          }
      }
        return setFUser;
        
    }
    public static set<Id> getRoleHierarchy(Id UserRoleId){
        Set<ID> finalUserIdSet= new set<Id>(); 
        if(UserRoleId <> null){
            finalUserIdSet.add(UserRoleId); 
            finalUserIdSet.addAll(getAllSubRoleIds(new set<Id>{UserRoleId}));  
        }
        return finalUserIdSet;
    }
    public static map<Id,set<Id>> getUsersByRoleId(map<Id,UserRole> mapUserRole, map<Id,User> mapUser){
        map<Id,set<Id>> mapUR = new map<Id,set<Id>>(); 
        for(User u: mapUser.values()){
            set<Id> setUsers = new set<Id>();
            if(mapUR.containsKey(u.userRoleId)){
                setUsers = mapUR.get(u.userRoleId);
            }
            setUsers.add(u.Id);
            mapUR.put(u.userRoleId,setUsers);
        }
        for(Userrole r: mapUserRole.values()){
            if(!mapUR.containsKey(r.Id))mapUR.put(r.Id,new set<Id>());
        }
        return mapUR;
    }
    public static map<Id,set<Id>> getRolesByRoleId(map<Id,UserRole> mapUserRole){
        map<Id,set<Id>> mapUR = new map<Id,set<Id>>(); 
        for(UserRole u: mapUserRole.values()){
            if(u.ParentRoleId <> null){
                set<Id> setUserroles = new set<Id>();
                if(mapUR.containsKey(u.ParentRoleId)){
                    setUserroles = mapUR.get(u.ParentRoleId);
                }
                setUserroles.add(u.Id);
                mapUR.put(u.ParentRoleId,setUserroles);
            }
        }
        for(Userrole r: mapUserRole.values()){
            if(!mapUR.containsKey(r.Id))mapUR.put(r.Id,new set<Id>());
        }
        return mapUR;
    }
    // To get all sub roles.
    public static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {

        Set<ID> currentRoleIds = new Set<ID>();
    
        // get all of the roles underneath the passed roles
       if (Schema.sObjectType.UserRole.fields.Id.isAccessible()){
        for(UserRole userRole :[select Id from UserRole where ParentRoleId 
             IN :roleIds AND ParentRoleID != null]) {
            currentRoleIds.add(userRole.Id);
        }
       }
        // go fetch some more rolls!
        if(currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
    
        return currentRoleIds;
    }
    
}