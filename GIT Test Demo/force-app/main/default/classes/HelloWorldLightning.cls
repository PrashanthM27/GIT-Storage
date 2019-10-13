public with sharing class HelloWorldLightning {
@AuraEnabled
    public static User getCurrentUser(){
        return [Select Id,FirstName,LastName from User where Id=:UserInfo.getUserId() limit 1];
        
    }
}