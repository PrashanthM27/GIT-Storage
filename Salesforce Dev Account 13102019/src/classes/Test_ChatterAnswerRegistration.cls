@isTest
public class Test_ChatterAnswerRegistration {
    static testMethod void validateAccountCreation(){
        User[] usr = [Select Id,FirstName,LastName from User];
        if(usr.size()==0){
            return ;
        }
    }
}