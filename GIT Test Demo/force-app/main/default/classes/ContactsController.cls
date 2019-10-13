public class ContactsController {
@AuraEnabled
    public static List<Contact> getContactDept(){
       Set<String> deptNames =new Set<String>();
        List<Contact> contList = [Select Id,Department FROM Contact];
        for(Contact ct:contList){
            if(ct.Department!=NULL){
                deptNames.add(ct.Department);
            }
        }
        List<String> finalStrList = new List<String>();
        finalStrList.addAll(deptNames);
        finalStrList.sort();
            return contList;
    }
    @AuraEnabled
    public static List<Contact> getDeptName(String deptName){
        List<Contact> contDeptList = [Select Id,FirstName,LastName,Department FROM Contact WHERE Department =:deptName];
        return contDeptList;
    }
}