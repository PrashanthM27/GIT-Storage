public class ToDoController {
    @AuraEnabled
    public static List<Contact> contactData(){
        return [SELECT ID,FirstName,LastName FROM Contact];
    }
    @AuraEnabled
    public static String saveTodoRecord(Contact cont){
        String message;
        Database.saveResult sr = Database.insert(cont,false);
        if(!sr.isSuccess()){
            for(Database.error err : sr.getErrors()){
                message += err.getMessage();
            }
        }
        return message;
    }
}